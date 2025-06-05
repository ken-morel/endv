const AUDIO = r".+\.(mp3|ogg|wav|oga)$"
const SIGTSTP = 20
const SIGCONT = 18
const SIGINT = Base.SIGINT

isaudio(path::String) = !isnothing(match(AUDIO, path))

mutable struct AudioPlayer
  file::String
  volume::Float64
  processid::Union{Nothing,Int}
  shouldrun::Bool
  playing::Bool
  AudioPlayer(file::String) = new(file, 100.0, nothing, true, false)
end
function showaudioplayerhelp()
  println("""
  p -> play/pause
  x -> stop ffplay process
  q -> close julia
  """)
end
function checkffplay()::Bool
  try
    #@assert system("ffplay -version") == 0
    true
  catch
    false
  end
end
function init!(player::AudioPlayer)::Bool
  if !checkffplay()
    return false
  end
  player.shouldrun = true
  player.volume = 100.0
  player.file = player.file |> abspath |> normpath # Ensure absolute path
  return true
end
function start!(player::AudioPlayer)::Bool
  try
    player.processid = forkcmd(
      "ffplay -nodisp -autoexit -hide_banner -i $(player.file)"
    )
    println("launched on pid $(player.processid)\n"^20)
    player.playing = true
    true
  catch
    println("Error starting ffplay process")
    false
  end
end
exited(player::AudioPlayer) = !isprocessrunning(player.processid)
function loop!(player::AudioPlayer)
  showaudioplayerhelp()
  try
    while player.shouldrun
      exited(player) && break
      handleinput!(player)
    end
  catch e
    if e isa InterruptException
      println("Exiting gracefully")
    end
  end
  if !exited(player)
    println("player running in background ...")
    0
  else
    println("player stopped")
    0
  end
end
function toggleplay!(player::AudioPlayer)
  if exited(player)
    println("ffplay process exited, cannot toggle play/pause.")
    return
  end
  if player.playing
    try
      killpid(player.processid, SIGTSTP)
      player.playing = false
    catch e
      println("Error sending stop signap to player")
    end
  else
    try
      killpid(player.processid, SIGCONT)
      player.playing = true
    catch
      println("Error sending play signal to player")
    end
  end
end
function handleinput!(player::AudioPlayer)
  input = prompt("> ")
  print("\033[2K\r")
  if exited(player)
    println("ffplay process exited.")
    player.shouldrun = false
    return
  end
  if input == "p"
    println("toggleing play pause")
    toggleplay!(player)
  elseif input == "x"
    try
      killpid(player.processid, SIGINT)
      player.playing = false
      player.shouldrun = false
    catch
      println("Error sending STOP signal")
    end
  elseif input == "q"
    println("Quitting Julia control loop. ffplay may continue playing at $(player.processid) if not stopped.")
    player.shouldrun = false
  else
    println("Unknown command: '$input'. Use 'p' to play/pause, 'x' to detach, or 'q' to quit.")
  end
end
function playaudio(file::String)::Cint
  player = AudioPlayer(file)
  if !init!(player)
    return
  end
  start!(player)
  loop!(player)
end

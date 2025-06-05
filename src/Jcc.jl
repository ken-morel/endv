"""
    module Jcc

A module to provide helpful tools compiling with juliac.
uses jcclib.
"""
module Jcc
export setjccpath, prompt, print, println

combinecmd(parts::Vector{<:Any})::String = first(parts) * " " * join(parts[2:end] .|> String .|> shellescape, " ")
jccpath::String = "./jcclib.so"

function setjccpath(path::String)
  global jccpath = path
end

println(txt) = Base.println(Core.stdout, txt)
print(txt) = Base.print(Core.stdout, txt)


"""
    prompt(prompttext::String, buffersize::Int = 256)::Union{String, Nothing}

"""
function prompt(prompttext::String; buffersize::Int=256)::Union{String,Nothing}
  # inputα = C_NULL
  # @ccall printf(prompttext::String)::Cint
  # bufferbytesize = buffersize * sizeof(Cchar)
  # inputα = @ccall malloc(bufferbytesize)::Cstring
  # if inputα == C_NULL
  #   return nothing
  # end
  # fgetresult = @ccall fgets(inputα::Cstring, buffersize::Cint)
  inputα = C_NULL
  try
    inputα::Cstring = ccall(
      (:prompt, jccpath),
      Cstring,
      (Cstring, Cint),
      prompttext,
      buffersize
    )::Cstring
    if inputα == C_NULL
      println("Got no input from jcclib")
      nothing
    else
      input::String = unsafe_string(inputα)
      ccall(
        (:freestr, jccpath),
        Cvoid,
        (Cstring,),
        inputα
      )
      input
    end
  catch
    println("An error occured calling c library, check it is at $jccpath")
    nothing
  end
end

"""
    function system(command::String)

just call c system.
"""
function system(command::String)
  @ccall system(command::Cstring)::Cint
end
system(cmd::Vector{<:Any}) = system(combinecmd(cmd))

forkcmd(parts::Vector{<:Any}) = forkcmd(combinecmd(parts))

function forkcmd(command::String)::Cint
  ccall(
    (:forkcmd, jccpath),
    Cint,
    (Cstring,),
    command
  )
end

function killpid(pid::Int, signal::Int)::Cint
  println("running command: kill -s $signal $pid")
  system("kill -s $signal $pid")
end

function isprocessrunning(pid::Int)::Bool
  status = system("kill -s 0 $pid")
  if status == 0
    true
  else
    false
  end
end

shellescape(part::String)::String = "'$part'"

function Jccsleep(time::Float32)
  @ccall sleep(time::Cfloat)::Cvoid
end

end

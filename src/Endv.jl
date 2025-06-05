module Endv
using SHA: sha1
using ..Jcc: print, println, prompt, system, sleep, forkcmd, isprocessrunning, killpid

function openexternally(path::String)::Cint
      system(["swaymsg", "exec", "xdg-open", path])
end

include("endvjl/cache.jl")

include("endvjl/imagemagic.jl")
include("endvjl/image.jl")
include("endvjl/pdf.jl")
include("endvjl/audio.jl")

function viewdefault(path::String)
  system(["xdg-open", path])
  0
end

function viewfile(path::String)::Cint
  if isimage(path)
    viewimage(path)
  elseif ispdf(path)
    viewpdf(path)
  elseif isaudio(path)
    playaudio(path)
  else
    viewdefault(path)
  end
end
end

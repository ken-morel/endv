module Endv
using SHA: sha1
using ..Jcc: print, println, prompt, system

include("endvjl/cache.jl")

include("endvjl/image.jl")

function viewdefault(path::String)
  system(["xdg-open", path])
  0
end

function viewfile(path::String)::Cint
    if isimage(path)
      viewimage(path)
    else
      viewdefault(path)
    end
end
end

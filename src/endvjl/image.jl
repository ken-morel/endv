const CHAFA_SUPPORTED = r".*\.(png|jpe?g|tif?f|gif)$"
const IMAGE = r".*\.(png|jpe?g|tif?f|webp|gif|svg)$"



ischafasupported(path::String)::Bool = !isnothing(match(CHAFA_SUPPORTED, path))
isimage(path::String)::Bool = !isnothing(match(IMAGE, path))

function converttogif(path::String)
  gifcache = gifcachefile(path)
  magic = getimagemagic()
  system([magic, path, gifcache])
  gifcache
end


function viewimagewithchafa(path::String, fullwidth::Bool=false)::Cint
  cmd::Vector{String} = ["chafa", "--align=mid,mid", "--work=9", "--symbols=all"]
  fullwidth && push!(cmd, "--fit-width")
  push!(cmd, path)
  try
    system(cmd)
    input = prompt("hit enter to exit> ")
    if input == "S"
      openexternally(path)
    elseif input == "f"
      viewimagewithchafa(path, !fullwidth)
    end
  catch
    println("Exciting gracefully")
  end
  0
end

function viewimage(path::String)::Cint
  if ischafasupported(path)
    viewimagewithchafa(path)
  else
    cachedpath = converttogif(path)
    viewimagewithchafa(cachedpath)
  end
end


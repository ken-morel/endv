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


function viewimagewithchafa(path::String)::Cint
  try
    system(["chafa", path])
    prompt("hit enter to exit> ")
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


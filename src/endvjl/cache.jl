function endvcache()::String
  # mktempdir() 126 errors gone!
  mkpath(joinpath(homedir(), ".cache", "endview")) # Well, this MUST work, else.
end
function gifcachefile(file::String)::String
  cachepath = joinpath(endvcache(), "gifcache") |> mkpath
  stem = file |> sha1 |> bytes2hex
  joinpath(cachepath, stem * ".gif")
end
function wavcachefile(file::String)::String
  cachepath = joinpath(endvcache(), "wavcache") |> mkpath
  stem = file |> sha1 |> bytes2hex
  joinpath(cachepath, stem * ".wav")
end


function pdfcachefolder(file::String)::String
  cachepath = joinpath(endvcache(), "pdfcache") |> mkpath
  stem = file |> sha1 |> bytes2hex
  joinpath(cachepath, stem) |> mkpath
end

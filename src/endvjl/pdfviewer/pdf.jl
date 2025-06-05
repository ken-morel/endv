struct PdfInfo
  path::String
  raw::Dict{String,String}
  npages::UInt
end

function getpdfinfo(cachepath::String, path::String)::PdfInfo
  infofile = joinpath(cachepath, "info.txt")
  system("pdfinfo '$path' >> '$infofile'")
  info = Dict{String,String}()
  open(infofile) do file
    while !eof(file)
      line = readline(file)
      ':' ∉ line && continue
      pair = strip.(split(line, ":"; limit=2))
      length(pair) != 2 && continue
      key, value = pair
      info[lowercase(key)] = value
    end
  end
  npages = try
    parse(UInt, info["pages"])
  catch
    1
  end
  PdfInfo(path, info, npages)
end

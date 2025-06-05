function pageimagecache(pdfcache::String, page::UInt)
  folder = joinpath(pdfcache, "pages") |> mkpath
  joinpath(folder, "$page.png")
end

cachepdfpagetoimage(pdf::String, page::UInt, output::String) = system([
  getimagemagic(), "-density", "300", "-quality", "100", "-flatten", "-background", "white", "$pdf[$(page - 1)]", output
])

function pageimagecache(pdfcache::String, page::UInt)
  folder = joinpath(pdfcache, "pages") |> mkpath
  joinpath(folder, "$page.png")
end

cachepdfpagetoimage(pdf::String, page::UInt, output::String) = system([
  getimagemagic(), "$pdf[$(page - 1)]", output
])

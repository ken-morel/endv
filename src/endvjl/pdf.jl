include("pdfviewer.jl")
ispdf(path::String) = endswith(path, ".pdf")
function viewpdf(path::String)::Cint
  cachepath = pdfcachefolder(path)
  info = getpdfinfo(cachepath, path)
  viewer = PdfViewer(info, cachepath)
  run!(viewer)
end



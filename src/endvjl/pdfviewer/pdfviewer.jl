mutable struct PdfViewer
  currentpage::UInt
  shouldrun::Bool
  pdfinfo::PdfInfo
  cachefolder::String
  PdfViewer(info::PdfInfo, cachefolder::String) = new(
    one(UInt),
    false,
    info,
    cachefolder,
  )
end

mutable struct PdfViewer
  currentpage::UInt
  shouldrun::Bool
  pdfinfo::PdfInfo
  cachefolder::String
  fullwidth::Bool
  PdfViewer(info::PdfInfo, cachefolder::String) = new(
    one(UInt),
    false,
    info,
    cachefolder,
    false
  )
end

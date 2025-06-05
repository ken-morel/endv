function mainloop!(view::PdfViewer)::Cint
  view.shouldrun = true
  show(view)
  while view.shouldrun
    handleinput!(view) && show(view)
  end
  0
end

function show(view::PdfViewer)
  imagepath = pageimagecache(view.cachefolder, view.currentpage)
  if !isfile(imagepath)
    cachepdfpagetoimage(view.pdfinfo.path, view.currentpage, imagepath)
  end
  cmd = ["chafa", "--align=mid,mid", "--work=9", "--symbols=all"]
  view.fullwidth && push!(cmd, "--fit-width")
  push!(cmd, imagepath)
  system(cmd)
  println("Page $(view.currentpage) of $(view.pdfinfo.npages)")
end

function handleinput!(view::PdfViewer)::Bool
  entry = prompt("> ")
  if entry == "q"
    view.shouldrun = false
  elseif entry == "n"
    if view.currentpage < view.pdfinfo.npages
      view.currentpage += 1
      true
    else
      false
    end
  elseif entry == "p"
    if view.currentpage > 1
      view.currentpage -= 1
      true
    else
      false
    end
  elseif entry == "C"
    rm(view.cachefolder; recursive=true)
    mkpath(view.cachefolder)
    false
  elseif entry == "f"
    view.fullwidth = !view.fullwidth
    true
  elseif entry == "S"
    openexternally(view.pdfinfo.path)
  else
    try
      page = parse(UInt, entry)
      if page > 0 && page <= view.pdfinfo.npages
        view.currentpage = page
        true
      else
        false
      end
    catch
      false
    end
  end
end

function run!(view::PdfViewer)
  mainloop!(view)
end

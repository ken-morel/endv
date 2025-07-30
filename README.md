# endv
Hello 👋. I personally use nchat for as desktop whatsapp and yelegram client, 8n short it is a terminal client.

Nchat is a simple tool which permits you to view those files possibly from your terminal, it supports:
- gif, webp(stickers), and more formats viewing using chaffa on sixel or kitty graphics supporting terminals(kitty, ghostty, foot, ...). kitty graphics i find better since it works on tmux. this depends on `chafa`.
- audio listening using ffmpeg process controlled with signals sent via `pkill`.
- pdf viewing, by converting the pdf pages to images and viewing those with chafa.
- others open with `xdg-open`.

## what's special?
Yes, it does it's work, viewing files, but this project is more indeed of an example usage of juliac.jl teimmed compilation to buuld the source code and c bindings(since julia + juliac.jl lacs some feutures) into a small sized binary in less than 40s.

## Again, what special

Well, compilation with juliax.jl is still experimental, strict and limited language feautures such that not many things usefull are made with it.

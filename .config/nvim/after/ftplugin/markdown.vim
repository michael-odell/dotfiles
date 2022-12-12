"call ForceMyFormatOptions()
"
"setlocal wrap
"setlocal nolist
"setlocal linebreak
"setlocal textwidth=0
"setlocal wrapmargin=0
"
"setlocal foldmethod=expr
"" Might want a back for auto reformatting of paragraphs
"setlocal formatoptions-=a
"setlocal formatoptions-=c
"setlocal formatoptions-=j
"setlocal formatoptions+=l
setlocal formatoptions-=t
setlocal textwidth=100

"setlocal foldlevel=0
inoremap <buffer> <C-D> <C-R>=strftime("%Y-%m-%d")<CR>

setlocal spell
"setlocal autoindent
"setlocal nosmartindent

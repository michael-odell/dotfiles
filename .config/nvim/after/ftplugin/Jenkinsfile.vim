call ForceMyFormatOptions()

set fo-=t

setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal smarttab
setlocal expandtab
setlocal textwidth=100

" From smartindent help -- don't move to the far left when pound character is inserted.  It must
" work with cindent too, becuase vim-polyglot's Jenkinsfile setting uses that.
inoremap # X#

setlocal comments=b://,b:#,fb://-,fb:#-

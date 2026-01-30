" From smartindent help -- don't move to the far left when pound character is inserted.  It must
" work with cindent too, becuase vim-polyglot's Jenkinsfile setting uses that.
inoremap # X#

setlocal comments=b://,b:#,fb://-,fb:#-

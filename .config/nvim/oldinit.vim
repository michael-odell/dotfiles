"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Miscellaneous Settings
" Note: mapleader is set in lazy-nvim.lua (must be set before lazy.nvim loads)

set mouse=a

" Swapfile directory -- two slashes mean to use the full file path when
" generating the temporary filename
set dir=$HOME/tmp/nvim//
set viewdir=$HOME/tmp/nvim/view//

nnoremap <leader>g :diffget<CR>
nnoremap <leader>p :diffput<CR>

" Copy the whole file to clipboard
noremap <leader>c :silent w !yank<CR>

" Copy to system clipboard
vnoremap <leader>y :w !yank<CR>

noremap <leader>x :!chmod +x %<CR>

set hidden
set title
set history=1000
set showmode
set number
set ruler

set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.a,core

set shortmess+=filmnrxA

set nojoinspaces

set splitbelow
set splitright

set nowrap

command! WQ wq
command! Wq wq
command! W w
command! Q q
command! Wall wall
command! Wqall wqall

" stay in visual mode upon shift
vnoremap < <gv
vnoremap > >gv

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PRJ-related

function! PrjCs(prjname)
    let l:prjroot = system("prj root " . a:prjname)
    :execute 'cd' l:prjroot
endfunction

function! PrjNames(ArgLead, CmdLine, CursorPos)
    return system("prj names")
endfunction

function! PrjFiles()
    return system("prj files")
endfunction

function! PrjFilenames()
    return system("prj filenames")
endfunction

command! -nargs=1 -complete=custom,PrjNames Cs :call PrjCs(<q-args>)
command! -nargs=1 -complete=custom,PrjNames CS :call PrjCs(<q-args>)

"command! -nargs=1 -complete=custom,PrjFilenames E :e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Restore cursor and persistent undo -- stolen from spf13
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

set undofile                " So is persistent undo ...
set undodir=$HOME/tmp/nvim/undo
set undolevels=10000        " Maximum number of changes that can be undone
set undoreload=10000        " Maximum number lines to save for undo on a buffer reload

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Colors

highlight Comment cterm=italic

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Indentation

set scrolloff=3

set backspace=indent,eol,start
set autoindent
set shiftround
set textwidth=105

" 2019-10-25: The vim wiki suggests that you should basically only turn cident or smartindent on for specific filetypes
" where you find you need it.  I'm turning them off for now globally. (autoindent just copies previous indent and is
" still useful)
" Use cindent, but make sure that it never moves back to the left edge upon pound key
"set cindent
"set cinkeys-=0#
"set indentkeys-=0#
" List of words that cause next line to get further indented under cindent or smartindent -- probably should be filetype
" specific
"set cinwords=

filetype plugin indent on

" 2019-10-25:  (See above about cindent and smartindent).  Smartindent's help page says the following inoremap will stop
" it from automatically moving to far left upon insertion of # characters.
" set smartindent
"inoremap # X#


set nostartofline

" *Tip* :retab will replace all the tabs in the file with spaces (well..
" it will adjust the file to match these settings)
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab           "(Expand tabs into spaces)

" NOTE: Several of my ftplugin "after" scripts change indentation settings


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Format Options
" NEVER auto-wrap text while typing. The FileType autocmd in init.lua also
" enforces this after ftplugins load, but set the global default too.
set formatoptions-=t

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Searching
set showmatch           " Show matching brackets
set ignorecase          " Case insensitive searching
set smartcase           " Smart case matching
set incsearch           " Incremental Search
set hlsearch            " highlight matches - :nohl to turn it off


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! ToggleAutoFormat()
	if &fo =~ 'a'
		setlocal fo-=a
	else
		setlocal fo+=a
	endif
endfunction
noremap <leader>f :call ToggleAutoFormat()<CR>

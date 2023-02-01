
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Set up VimPlug

" Install if necessary
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/matchit.zip'

set laststatus=2
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
" Replace the 'utf-8[unix] section with formatoptions
let g:airline_section_y = '%{gutentags#statusline()}%{&et? "" : "<<TABS>>"} [%{&ft}:%{&fo}]'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 1
" The plugin claims to only have 'very basic' support for term.  But it also seems to think my
" full-gui-color terminal uses gui colors.
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=grey22
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=grey25
let g:indent_guides_color_change_percent = 3 "default is 10
"let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 1
let g:indent_guides_enable_on_vim_startup = 1

" This automatically runs ctags on projects so that they're quickly set up for vim's use.  It does
" cause .tags files to get generated, though.
let g:gutentags_ctags_tagfile='.tags'
Plug 'ludovicchabant/vim-gutentags'

let g:polyglot_disabled = ['yaml', 'bash', 'ruby']
let g:vim_json_syntax_conceal = 0
Plug 'sheerun/vim-polyglot'

let g:vim_json_syntax_conceal = 0
Plug 'sheerun/vim-polyglot'
let g:show_spaces_that_precede_tabs=1
let g:better_whitespace_enabled=1
Plug 'ntpeters/vim-better-whitespace'

Plug 'altercation/vim-colors-solarized'
let g:solarized_termtrans = 0

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = [ 'hg', 'git' ]

Plug 'tpope/vim-rsi'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rake'
noremap <A-o> <esc>:A<CR>
map <leader>o <esc>:A<CR>

Plug 'martinda/Jenkinsfile-vim-syntax'

" Turn off lsp diagnostics
"let g:lsp_diagnostics_enabled = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_highlight_references_enabled = 1
let g:lsp_signs_enabled = 1
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'

" For many language server types, install them automatically.  Try LspInstallServer in a supported
" language.  See :help vim-lsp-settings-plugin for more
"Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Miscellaneous Settings

let mapleader=","

set mouse=a

" Swapfile directory -- two slashes mean to use the full file path when
" generating the temporary filename
set dir=$HOME/tmp/nvim//
set viewdir=$HOME/tmp/nvim/view//

nnoremap <leader>g :diffget<CR>
nnoremap <leader>p :diffput<CR>

" Copy the whole file to clipboard
noremap <leader>c :silent w !yank<CR>

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

if $ITERM_PROFILE == 'Solarized Dark'
    set background=dark
    colorscheme solarized
    let g:airline_theme='solarized'
    let g:airline_solarized_bg='dark'

"elseif $ITERM_PROFILE == 'Solarized Light'
else
    set background=light
    colorscheme solarized
    let g:airline_theme='solarized'
    let g:airline_solarized_bg='light'

endif

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
""" Searching
set showmatch           " Show matching brackets
set ignorecase          " Case insensitive searching
set smartcase           " Smart case matching
set incsearch           " Incremental Search
set hlsearch            " highlight matches - :nohl to turn it off


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ftplugins screw with things.  All of my 'after' scripts for ftplugins call
" this function to correct formatoptions after loading the ftplugin. Idea came
" from http://peox.net/articles/vimconfig.html
function! ForceMyFormatOptions()
	setlocal formatoptions+=n

	" Do not automatically extend comments upon <CR> or adding a new line.
	" Automatic wrapping will still do so.
	setlocal formatoptions-=r
	setlocal formatoptions-=o
    " But do remove the comment leader when joining lines
    setlocal formatoptions+=j

endfunction

function! ToggleAutoFormat()
	if &fo =~ 'a'
		setlocal fo-=a
	else
		setlocal fo+=a
	endif
endfunction
noremap <leader>f :call ToggleAutoFormat()<CR>

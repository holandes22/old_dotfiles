scriptencoding utf-8

""" Basics
""" ------

" indent by 2 spaces by default
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

set formatoptions=tcrq
set textwidth=80

" give more space to active window
set winheight=15
set winminheight=5
set winwidth=80

" hide mouse after chars typed
set mousehide

" do not wrap lines
set nowrap

" show file title in terminal
set title

""" Keymaps
""" -------

let g:mapleader = ','
map <leader>aa ggVG "select all
let g:netrw_liststyle=3
map <leader>k :Explore<cr>

" enable omni syntax completion
set omnifunc=syntaxcomplete#Complete

" highlight search results
set hlsearch
" incremental search, search as you type
set incsearch
" ignore case when searching
set ignorecase smartcase
" ignore case when searching lowercase
set smartcase

" line numbering
set number

"" TODO: create a virtualenv dedicated for vim on create
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'

" persist undo
if isdirectory($HOME . '/.config/nvim/undo') == 0
  :silent !mkdir -p ~/.config/nvim/undo > /dev/null 2>&1
endif
set undodir=./.vim-undo//
set undodir+=~/.vim/undo//
set undodir+=~/.config/nvim/undo//
set undofile

""" Plugins

call plug#begin('~/.config/nvim/plugged')

  """ General Vim
  Plug 'ctrlpvim/ctrlp.vim'
    let g:ctrlp_map = '<Leader>p'
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules|bower_components|build|frontend\/tmp|frontend\/dist|tmp|dist|htmlcov)$',
        \ 'file': '\v\.(exe|so|dll|pyc|beam)$',
        \ }

  Plug 'altercation/vim-colors-solarized'

  Plug 'tomtom/tcomment_vim'

  Plug 'vim-airline/vim-airline'

  Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme = 'luna'
    let g:airline_branch_prefix = '⎇ '
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''

  """ Git
  Plug 'https://github.com/tpope/vim-fugitive.git'

  """ Languages general
  Plug 'sheerun/vim-polyglot'
    let g:polyglot_disabled = ['elm']

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1
    if !exists('g:deoplete#omni#input_patterns')
      let g:deoplete#omni#input_patterns = {}
    endif
    " use tab for completion
    inoremap <expr><Tab> pumvisible() ? "\<c-n>" : "\<Tab>"
    inoremap <expr><S-Tab> pumvisible() ? "\<c-p>" : "\<S-Tab>"

  Plug 'neomake/neomake'
    " Run Neomake when I save any buffer
    augroup localneomake
      autocmd! BufWritePost * Neomake
    augroup END

  """ Python
  Plug '/davidhalter/jedi'
  Plug 'davidhalter/jedi-vim'
    let g:jedi#popup_on_dot = 0
    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#show_call_signatures = 0
  Plug 'zchee/deoplete-jedi'

  """ Elixir
  Plug 'slashmili/alchemist.vim'

  """ Elm
  Plug 'elmcast/elm-vim'
    let g:elm_format_autosave = 1

call plug#end()

""" Theme
""" -----

" let g:solarized_termcolors=256 " uncomment if terminal has no solarized color scheme
set background=dark
syntax enable
colorscheme solarized


""" Filetypes
""" ---------

augroup erlang
  autocmd!
  autocmd BufNewFile,BufRead *.erl setlocal tabstop=4
  autocmd BufNewFile,BufRead *.erl setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.erl setlocal softtabstop=4
  autocmd BufNewFile,BufRead relx.config setlocal filetype=erlang
augroup END

augroup elm
  autocmd!
  autocmd BufNewFile,BufRead *.elm setlocal tabstop=4
  autocmd BufNewFile,BufRead *.elm setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.elm setlocal softtabstop=4
augroup END

augroup python
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4
  autocmd BufNewFile,BufRead *.py setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.py setlocal softtabstop=4
augroup END

augroup dotenv
  autocmd!
  autocmd BufNewFile,BufRead *.envrc setlocal filetype=sh
augroup END

augroup markdown
  autocmd!
  autocmd FileType markdown setlocal textwidth=80
  autocmd FileType markdown setlocal formatoptions=tcrq
augroup END

augroup viml
  autocmd!
  autocmd FileType vim setlocal textwidth=80
  autocmd FileType vim setlocal formatoptions=tcrq
augroup END

""" Delete trailing white space on save
func! DeleteTrailingWS()
  exe 'normal mz'
  %s/\s\+$//ge
  exe 'normal `z'
endfunc

augroup whitespace
  autocmd BufWrite * silent call DeleteTrailingWS()
augroup END

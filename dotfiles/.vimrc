" Vim config - optimized for Python, Elixir and Web

set nocompatible

call plug#begin('~/.vim/plugged')

    " General Vim
      Plug 'ctrlpvim/ctrlp.vim'
      Plug 'altercation/vim-colors-solarized'
      Plug 'scrooloose/nerdcommenter'
      Plug 'scrooloose/syntastic'
      Plug 'vim-airline/vim-airline'
      Plug 'vim-airline/vim-airline-themes'

    " Git
      Plug 'https://github.com/tpope/vim-fugitive.git'

    " Python
      Plug 'davidhalter/jedi-vim'
      Plug 'hdima/python-syntax'

    " Rust
      Plug 'rust-lang/rust.vim'

    " Elixir
      Plug 'elixir-lang/vim-elixir'
      Plug 'slashmili/alchemist.vim'

    " Elm
      Plug 'elmcast/elm-vim'

    " Web
      Plug 'mattn/emmet-vim'
      Plug 'mustache/vim-mustache-handlebars'
      Plug 'cakebaker/scss-syntax.vim'

    " Formatting
      Plug 'chase/vim-ansible-yaml'

call plug#end()

" Prepare tmp and backup folders
if !isdirectory("~/.vim/tmp")
    silent !mkdir -p ~/.vim/tmp
endif
if !isdirectory("~/.vim/backup")
    silent !mkdir -p ~/.vim/backup
endif

"Set Vim defaults
    set t_Co=256
    set laststatus=2
    set noshowmode
    set backspace=indent,eol,start
    set history=256                " Number of things to remember in history.
    set timeoutlen=250             " Time to wait after ESC (default causes an annoying delay)
    set clipboard+=unnamed         " Yanks go on clipboard instead.
    set modeline
    set modelines=5                " default numbers of lines to read for
    set autowrite                  " Writes on make/shell commands
    set autoread
    set hidden                     " The current buffer can be put to the background without writing to disk
    set hlsearch                   " highlight search
    set incsearch                  " show matches while typing
    let g:is_posix = 1             " vim's default is archaic bourne shell,
    set ts=2                       " tabstop tab size eql 4 spaces
    set sts=2                      " softtabstop
    set sw=2                       " shiftwidth
    set expandtab
    set tw=0 " Text Width, avoid text wrapping
    set backup " make backup files
    set backupdir=~/.vim/backup " where to put backup files
    set clipboard+=unnamed " share windows clipboard
    set directory=~/.vim/tmp " directory to place swap files in
    set mousehide                 " Hide mouse after chars typed
    set showmatch                 " Show matching brackets.
    set novisualbell              " No blinking
    set noerrorbells              " No noise.
    " set colorcolumn=121            " Right column
    set encoding=utf8
    set autoindent smartindent
    set nowrap " Do not wrap lines
    set incsearch
    " Removing trailing whitespaces.
    autocmd FileType * autocmd BufWritePre <buffer> :%s/\s\+$//e
    autocmd FileType py setlocal ts=4 sw=4 sts=4
    " Mark trailing whitespace
    set list listchars=trail:_
    highlight SpecialKey ctermfg=DarkGray ctermbg=yellow
    syntax on
    syntax enable
    " filetype plugin on
    filetype plugin indent on

    " give more space to active window
    set winheight=15
    set winminheight=5
    set winwidth=80
" Vim defaults end


" Keymaps
" -------
let mapleader = ","
map <leader>aa ggVG "select all
call togglebg#map("<F5>")

" Exploration
" -----------
let g:netrw_liststyle=3
map <leader>k :Explore<cr>

" Colorscheme
" -----------

" Plug 'ayu-theme/ayu-vim'
" not working with TMUX, but nice theme, check it out again in a few months.
" set termguicolors
"let ayucolor="mirage"
" colorscheme ayu

if (!empty($TMUX))
  set term=screen-256color
endif
set background=dark
" let g:solarized_termcolors=256 " uncomment if terminal has no solarized color scheme
colorscheme solarized

" Vim Plugin Configs

" CtrlP
let g:ctrlp_map = '<Leader>p'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules|bower_components|build|frontend\/tmp|frontend\/dist|tmp|dist|htmlcov)$',
    \ 'file': '\v\.(exe|so|dll|pyc|beam)$',
    \ }

" syntastic
let g:syntastic_check_on_open = 0
let g:syntastic_python_checkers = ['pylint', 'pep8']
let g:syntastic_javascript_checkers = ['jshint']

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures = 0

" Python-syntax
let python_highlight_all = 1

" Handlebars
let g:mustache_abbreviations = 1

" emmet-vim
let g:user_emmet_leader_key = '<c-x>'

" airline vim
let g:airline_theme = 'luna'
let g:bufferline_echo = 0
let g:airline_branch_prefix = '⎇ '
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" elm-vim
let g:elm_format_autosave = 1

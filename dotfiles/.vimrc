" Vim config - optimized for Python, JS
set nocompatible " be iMproved

" Vundle
    " Setting up Vundle - the vim plugin bundler
        let iCanHazVundle=1
        let vundle_readme=expand("~/.vim/bundle/vundle/README.md")
        if !filereadable(vundle_readme)
            echo "Installing Vundle.."
            echo ""
            silent !mkdir -p ~/.vim/bundle
            silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
            let iCanHazVundle=0
        endif
        set rtp+=~/.vim/bundle/vundle/
        call vundle#rc()
        Bundle 'gmarik/vundle'
    " Setting up Vundle - the vim plugin bundler end

    " Bundles
        " General Vim
            Bundle 'ctrlpvim/ctrlp.vim'
            Bundle 'altercation/vim-colors-solarized'
            Bundle 'scrooloose/nerdcommenter'
            Bundle 'scrooloose/syntastic'
            Bundle 'bling/vim-airline'
            Bundle 'blueyed/vim-diminactive'
        " General Vim end

        " Git
            Bundle 'https://github.com/tpope/vim-fugitive.git'

        " Python
            Bundle 'davidhalter/jedi-vim'
            Bundle 'hdima/python-syntax'
        " Python end

        " Rust
            Bundle 'rust-lang/rust.vim'

        " web
            Bundle 'mattn/emmet-vim'
            Bundle 'mustache/vim-mustache-handlebars'
            Bundle 'groenewege/vim-less'
        " web end

        " Formatting
            Bundle 'chase/vim-ansible-yaml'
        " Formatting end
    " Bundles end

    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
    :BundleInstall
    endif
" Vundle end

" Prepare tmp and backup folders
if !isdirectory("~/.vim/tmp")
    silent !mkdir -p ~/.vim/tmp
endif
if !isdirectory("~/.vim/backup")
    silent !mkdir -p ~/.vim/backup
endif

"Set Vim defaults
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
    set ts=4                       " tabstop tab size eql 4 spaces
    set sts=4                      " softtabstop
    set sw=4                       " shiftwidth
    set expandtab
    set tw=120
    set autoindent
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
    set ai "Auto indent
    set si "Smart indet
    set autoindent smartindent
    set nowrap " Do not wrap lines
    set incsearch
    " Removing trailing whitespaces.
    autocmd FileType * autocmd BufWritePre <buffer> :%s/\s\+$//e
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html*,hbs,handlebars,jinja*,j2,js,javascript,*css,less,json,yml,yaml setlocal ts=2 sw=2 sts=2  "html, htmldjango, jinja
    " Mark trailing whitespace
    set list listchars=trail:_
    highlight SpecialKey ctermfg=DarkGray ctermbg=yellow
    try
        lang en_US
    catch
    endtry
    syntax on
    syntax enable
    " filetype plugin on
    filetype plugin indent on " load filetype plugins/indent settings

    " give more space to active window
    set winheight=15
    set winminheight=5
    set winwidth=80
" Vim defaults end


" Keymaps
    let mapleader = ","
    " Select All
    map <leader>aa ggVG
    call togglebg#map("<F5>")


" Keymaps end

" Filetype overrides
   " Python
   " Python end
" Filetype overrides end

" Vim Plugin Configs
    " Solarized

    " Handle TERM quirks in vim
    if $TERM =~ 'screen'
        nmap <Esc>OH <Home>
        imap <Esc>OH <Home>
        nmap <Esc>OF <End>
        imap <Esc>OF <End>
    endif

    " Solarized
    set background=dark
    let g:solarized_termcolors=256
    colorscheme solarized

    " CtrlP
    let g:ctrlp_map = '<Leader>p'
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules|bower_components|build|frontend\/tmp|frontend\/dist)$',
        \ 'file': '\v\.(exe|so|dll|pyc)$',
        \ }

    " syntastic
    let g:syntastic_python_checkers = ['pylint', 'pep8']
    let g:syntastic_check_on_open = 0
    let g:syntastic_python_pylint_args='--rcfile=~/.pylintrc'

    let g:syntastic_javascript_checkers = ['jshint']

    " jedi-vim
    let g:jedi#popup_on_dot = 0
    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#show_call_signatures = 0

    " Python-sintax
    let python_highlight_all = 1

    " Handlebars
    let g:mustache_abbreviations = 1

    " emmet-vim
    let g:user_emmet_leader_key='<c-x>'

" Vim Plugin Configs end



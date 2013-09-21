set nocompatible

filetype on
filetype off

" Teach Vim to fish
if &shell =~# 'fish$'
  set shell=sh
endif

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle the Vundle
Bundle 'vundle'

" Dependencies
Bundle 'tpope/vim-repeat'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'tsaleh/vim-matchit'
Bundle 'mattn/webapi-vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'

" File management
Bundle 'scrooloose/nerdtree'
Bundle 'wincent/Command-T'

" Smart input
Bundle 'vim-scripts/Auto-Pairs'
Bundle 'msanders/snipmate.vim'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-commentary'

" Version control
Bundle 'tpope/vim-fugitive'
Bundle 'vim-scripts/hgrev'
Bundle 'phleet/vim-mercenary'

" Little helpers
Bundle 'tpope/vim-rails'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-characterize'
Bundle 'mattn/gist-vim'
Bundle 'tpope/vim-sleuth'
Bundle 'sjl/gundo.vim'
Bundle 'scrooloose/syntastic'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'tpope/vim-abolish'
Bundle 'mileszs/ack.vim'
Bundle 'hwartig/vim-seeing-is-believing'

" Syntax
Bundle 'othree/html5.vim'
Bundle 'neowit/vim-force.com'
Bundle 'juvenn/mustache.vim'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'kchmck/vim-coffee-script'
Bundle 'groenewege/vim-less'
Bundle 'dag/vim-fish'
Bundle 'nelstrom/vim-visual-star-search'

" Fancyness
Bundle 'jacquesbh/vim-showmarks'
Bundle 'dhruvasagar/vim-railscasts-theme'
Bundle 'bling/vim-airline'

filetype plugin indent on

runtime! init/settings.vim
runtime! init/**.vim
runtime! init/fancyness.vim

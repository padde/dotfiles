syntax on                      " enable syntax highlighting
set number                     " show line numbers

set expandtab                  " i like soft tabs
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set nowrap                     " do not wrap lines

set visualbell                 " no beeps please!

set encoding=utf-8             " utf-8 ftw!
set fileencoding=utf-8

set nohidden                   " do not store data about old buffers

set wildmenu                   " complete all the commands!
set wildmode=list:longest,full

set mouse=a                    " mouse support
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

let mapleader = ","            " nobody likes \ as leader!

set autoread                   " Reload changes if detected

set hlsearch                   " Search highlighting
set incsearch                  " Highlight as you type

set foldcolumn=1               " Show foldcolumn

" Share clipboard
if has('mac')
  set clipboard+=unnamed
endif

" persist undo history
set undodir=~/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

" " persist folds
" au BufWinLeave * silent! mkview
" au BufWinEnter * silent! loadview

" use syntax omnicomplete if no ft specific is available
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
  \	if &omnifunc == "" |
  \	 setlocal omnifunc=syntaxcomplete#Complete |
  \	endif
endif

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

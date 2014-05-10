if &compatible
  set nocompatible
end

filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" Vundle the Vundle
Bundle 'gmarik/Vundle.vim'

" Dependencies
Bundle 'tpope/vim-repeat'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'vim-scripts/matchit.zip'
Bundle 'mattn/webapi-vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'rizzatti/funcoo.vim'

" File management
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'pbrisbin/vim-mkdir'

" Smart input
Bundle 'vim-scripts/Auto-Pairs'
Bundle 'msanders/snipmate.vim'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-commentary'

" Version control
Bundle 'tpope/vim-fugitive'
Bundle 'phleet/vim-mercenary'
Bundle 'ludovicchabant/vim-lawrencium'
Bundle 'mhinz/vim-signify'

" Little helpers
Bundle 'tpope/vim-rails'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-characterize'
Bundle 'mattn/gist-vim'
Bundle 'ciaranm/detectindent'
Bundle 'sjl/gundo.vim'
Bundle 'scrooloose/syntastic'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'tpope/vim-abolish'
Bundle 'mileszs/ack.vim'
Bundle 'hwartig/vim-seeing-is-believing'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'tpope/vim-speeddating'
Bundle 'vim-scripts/PreserveNoEOL'

" Syntax
Bundle 'othree/html5.vim'
Bundle 'neowit/vim-force.com'
Bundle 'juvenn/mustache.vim'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'kchmck/vim-coffee-script'
Bundle 'groenewege/vim-less'
Bundle 'nelstrom/vim-visual-star-search'

" Fancyness
Bundle 'jacquesbh/vim-showmarks'
Bundle 'dhruvasagar/vim-railscasts-theme'
Bundle 'bling/vim-airline'
Bundle 'altercation/vim-colors-solarized'

filetype plugin indent on

syntax on                      " enable syntax highlighting
set number                     " show line numbers
set expandtab                  " i like soft tabs
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set visualbell                 " no beeps please!
set encoding=utf-8             " utf-8 ftw!
set fileencoding=utf-8
set nohidden                   " do not store data about old buffers
set wildmenu                   " complete all the commands!
set wildmode=list:longest,full
set mouse=a                    " mouse support
if has("mouse_sgr")            " fix mouse issues in wide terminal windows
  set ttymouse=sgr
else
  set ttymouse=xterm2
end
let mapleader = ","            " nobody likes \ as leader!
set autoread                   " Reload changes if detected
set hlsearch                   " Search highlighting
set incsearch                  " Highlight as you type
set ignorecase
set smartcase
set nolist                     " Do not show invisibles
set wrap                       " Wrap lines
set linebreak                  " Soft wrap
set formatoptions=croql
silent! set formatoptions+=j   " j is not always available
set foldcolumn=1               " Show foldcolumn
if has('mac')                  " Share clipboard
  set clipboard+=unnamed
endif
set undodir=~/.vim/undo        " persist undo history
set undofile
set undolevels=1000
set undoreload=10000
set splitbelow                 " natural split direction
set splitright

" Preserve EOL
let g:PreserveNoEOL = 1
let g:PreserveNoEOL_Function = function('PreserveNoEOL#Internal#Preserve')

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

" Show marks on the left
set updatetime=500
autocmd BufEnter * DoShowMarks

" Check syntax when opening a file
let g:syntastic_check_on_open=1

" Syntastic symbols
let g:syntastic_error_symbol='●'
let g:syntastic_warning_symbol='■'
let g:syntastic_style_error_symbol='○'
let g:syntastic_style_warning_symbol='□'

" force.com plugin settings
let g:apex_backup_folder        ='~/.force.com/backup'
let g:apex_temp_folder          ='~/.force.com/temp'
let g:apex_deployment_error_log ='~/.force.com/error.log'
let g:apex_properties_folder    ='~/.force.com/properties'

" Gist plugin settings
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" NERD tree settings
let g:NERDTreeChDirMode=2

" Write and quit
command! Wsudo :w !sudo tee %
command! -nargs=* -complete=file W w <args>
command! -nargs=* -complete=file WQ w <args>
command! -nargs=* -complete=file Wq wq <args>
command! Q q

" vimrc
command! Vimrc :e ~/.vimrc
autocmd! bufwritepost vimrc source % | AirlineRefresh

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <Leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <Leader>rt :RemoveTrailingWhitespace<CR>

" Diff with last saved version
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffWithSaved call s:DiffWithSaved()

" Reformat JSON
command! FormatJson %!python -m json.tool

" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" add line above/below in insert mode
imap jj <esc>o
imap JJ <esc>O

" seeing is believing
nmap <buffer> <Leader>sr <Plug>(seeing-is-believing-run)
xmap <buffer> <Leader>sr <Plug>(seeing-is-believing-run)
nmap <buffer> <Leader>sm <Plug>(seeing-is-believing-mark)
xmap <buffer> <Leader>sm <Plug>(seeing-is-believing-mark)

" autojump
function! s:Autojump(...)
  let path = system('autojump '.a:000[-1])
  exe 'cd '.escape(path, ' ')
  pwd
endfunction

function! s:AutojumpCompletion(A,L,P)
  let completions = []
  for completion in split(system('autojump --complete '.a:A), "\n")
    call add(completions, substitute(completion, '^.*__\d__', '', ''))
  endfor
  return completions
endfunction

command! -complete=customlist,s:AutojumpCompletion -nargs=* J call s:Autojump(<f-args>)

map <leader>j :J<space>

" ack/ag
nmap <leader>a :Ack<space>-i ""<left>

" nerdtree
nmap <Leader>d :NERDTreeToggle<CR>

" toggle wrap
function! ToggleWrap()
  if &wrap
    let g:ToggleWrapList = &list
    let g:ToggleWrapLbr = &lbr
    set list nolbr nowrap
  else
    if g:ToggleWrapList | set list | endif
    if g:ToggleWrapLbr | set lbr | endif
    set wrap
  endif
endfunction
nmap <silent> <leader>w :call ToggleWrap()<cr>

" Font
set guifont=Menlo\ Regular:h12

" Color scheme
if $PRESENTATION_MODE == 1
  colorscheme solarized
else
  colorscheme railscasts
endif

" Show invisibles as in Text Mate (with improvements)
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<

" Prettier look for splits
set fillchars+=vert:│

" Hightlight current line in gui
set cursorline

" Hide menu bar in MacVim
if has('gui_running')
  set guioptions=egmrt
endif

" Patch Railscasts color scheme
if g:colors_name == 'railscasts'
  hi Search cterm=NONE ctermbg=yellow ctermfg=red
  hi Search guibg=#eac43c guifg=#b5382d
  hi FoldColumn ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi SignColumn ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi hlShowMarks ctermfg=lightgrey ctermbg=none guifg=#bbbbbb guibg=NONE
  hi Error ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi Todo ctermfg=178 ctermbg=none guifg=orange guibg=NONE
endif

" Airline
set laststatus=2
set noshowmode
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_detect_modified=0
let g:airline_section_z = '%l:%c %p%%'
let g:airline#extensions#branch#enabled = 1

if $PRESENTATION_MODE == 1
  let g:airline_theme='solarized'
else
  let g:airline_theme='powerlineish'
  let g:airline_theme_patch_func = 'AirlineThemePatch'
  function! AirlineThemePatch(palette)
    if g:airline_theme == 'powerlineish'
      let a:palette.normal.airline_x[1] = '#404040'
      let a:palette.normal.airline_x[3] = 236
      let a:palette.normal.airline_b[1] = '#505050'
      let a:palette.normal.airline_b[3] = 238
      let a:palette.normal.airline_c[1] = '#404040'
      let a:palette.normal.airline_c[3] = 236
      let a:palette.normal.airline_y[1] = '#505050'
      let a:palette.normal.airline_y[3] = 238
      if type(get(a:palette.normal, 'airline_file')) == type([])
        let a:palette.normal.airline_file[1] = '#404040'
        let a:palette.normal.airline_file[3] = 236
      endif
    endif
  endfunction
endif

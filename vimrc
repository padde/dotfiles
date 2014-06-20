if &compatible
  set nocompatible
end

" Load Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Enable filetype detection
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Show line numbers
set number

" Default to soft tabs/two spaces
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Complete all the commands!
set wildmenu
set wildmode=list:longest,full

" Do not show invisibles
set nolist

" Do not wrap lines
set nowrap

" Soft wrap
set linebreak

" Mouse support
set mouse=a

" Fix mouse issues in wide terminal windows
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

" Share clipboard
set clipboard+=unnamed

" Nobody likes \ as leader!
let mapleader = ","

" UTF-8
set nobomb
set encoding=utf-8
set fileencoding=utf-8

" Reload changes if detected
set autoread

" Search highlighting
set hlsearch

" Highlight as you type
set incsearch
set ignorecase
set smartcase

" set global flag as default for substitution
set gdefault

" Auto-continue comments
set formatoptions=croql
silent! set formatoptions+=j

" Undo settings
set undofile
set undolevels=1000
set undoreload=10000

" Natural split direction
set splitbelow
set splitright

" Do not store data about old buffers
set nohidden

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Centralize administrational files
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo
set viewdir=~/.vim/view
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&viewdir))
  call mkdir(expand(&viewdir), "p")
endif

" Hide startup message
set shortmess=atI

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

" Check syntax when opening a file
let g:syntastic_check_on_open=1

" Syntastic symbols
let g:syntastic_error_symbol='●'
let g:syntastic_warning_symbol='■'
let g:syntastic_style_error_symbol='○'
let g:syntastic_style_warning_symbol='□'

" Gist plugin settings
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" NERD tree settings
let g:NERDTreeChDirMode=2

" Write and quit typo correction
command! Wsudo :w !sudo tee %
command! -nargs=* -bang -complete=file W w<bang> <args>
command! -nargs=* -bang -complete=file WQ w<bang> <args>
command! -nargs=* -bang -complete=file Wq wq<bang> <args>
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! -bang Wqa wqa<bang>
command! -bang WQa wqa<bang>

" Reload vimrc after saving it
autocmd! bufwritepost vimrc source % | AirlineRefresh

" Ctrl-P
let g:ctrlp_show_hidden = 1

" Clear CtrlP cache after saving and entering buffer
autocmd! bufwritepost * CtrlPClearCache
autocmd! bufenter * CtrlPClearCache

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
  " Disable caching because ag is fast enough
  let g:ctrlp_use_caching = 0
endif

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Reformat JSON
command! FormatJson %!python -m json.tool

" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Autojump
noremap <leader>j :J<space>

" Ack
nnoremap <leader>a :Ack -i ""<left>
nnoremap <silent>+ *:AckFromSearch<cr>
nnoremap <silent>- #:AckFromSearch<cr>
vnoremap <silent>+ :<c-u>VStarSearch<cr>:AckFromSearch<cr>
vnoremap <silent>- :<c-u>VPoundSearch<cr>:AckFromSearch<cr>

" NERDTree
nnoremap <leader>d :NERDTreeToggle<cr>

" Make RSpec dance with Spring
function! SetRspecCommand()
  " q - exit tmux's visual mode
  " C-u - clear existing input
  " C-c - abort currently running spec
  let common_prefix = 'q'

  let g:turbux_command_prefix = common_prefix
  let g:rspec_command = 'call Send_to_Tmux("'.common_prefix.'rspec {spec}\n")'

  call system('bundle show spring')
  if !v:shell_error
    let g:turbux_command_prefix = common_prefix.'spring'
    let g:rspec_command = 'call Send_to_Tmux("'.common_prefix.'spring rspec {spec}\n")'
  endif
endfunction
call SetRspecCommand()

let g:no_turbux_mappings = 1
map <leader>t <Plug>SendTestToTmux
map <leader><leader>t <Plug>SendFocusedTestToTmux
map <Leader>T :call RunAllSpecs()<CR>

command! Rmig call Send_to_Tmux("clear\nrake db:migrate\n")

map <leader>. :A<CR>


""" FANCYNESS

" Colors
set background=dark
colorscheme base16-default

" Very subtle splits
hi VertSplit ctermbg=none ctermfg=10 guibg=NONE guifg=#202020

" Show invisibles as in Text Mate (with improvements)
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<,nbsp:␣

" Prettier look for splits
set fillchars+=vert:│

" Hightlight current line
set cursorline

" Simple gutter colors
hi LineNr ctermbg=none guibg=NONE
hi FoldColumn ctermbg=none guibg=NONE
hi SignColumn ctermfg=red ctermbg=none guifg=red guibg=NONE
hi Error ctermfg=red ctermbg=none guifg=red guibg=NONE
hi Todo ctermfg=178 ctermbg=none guifg=orange guibg=NONE
hi SignifySignAdd ctermbg=none guibg=NONE
hi SignifySignDelete ctermbg=none guibg=NONE
hi SignifySignChange ctermbg=none guibg=NONE

" Airline
set laststatus=2
set noshowmode
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_z = '%l:%c %p%%'
let g:airline_section_b = '%{substitute(getcwd(), ".*\/", "", "g")}'
let g:airline_section_c = '%t'
let g:airline_mode_map = {
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'v'  : 'V',
  \ 'V'  : 'VL',
  \ 'c'  : 'CMD',
  \ '' : 'VB',
  \ }



" Local config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

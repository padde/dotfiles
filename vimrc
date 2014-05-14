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

" Show foldcolumn
set foldcolumn=1

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

" Wrap lines
set wrap

" Soft wrap
set linebreak

" Search highlighting
set hlsearch

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

" Highlight as you type
set incsearch
set ignorecase
set smartcase

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

" Centralize administrational files
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo
set viewdir=~/.vim/view

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

" Clear CtrlP cache after saving and entering buffer
autocmd! bufwritepost * CtrlPClearCache
autocmd! bufenter * CtrlPClearCache

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Reformat JSON
command! FormatJson %!python -m json.tool

" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Autojump
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
noremap <leader>j :J<space>

" Ack
nnoremap <leader>a :Ack<space>-i ""<left>

" NERDTree
nnoremap <leader>d :NERDTreeToggle<cr>



""" FANCYNESS

" Colors
colorscheme railscasts

" Show invisibles as in Text Mate (with improvements)
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<,nbsp:␣

" Prettier look for splits
set fillchars+=vert:│

" Hightlight current line
set cursorline

" Patch Railscasts color scheme
if g:colors_name == 'railscasts'
  hi Search cterm=NONE ctermbg=yellow ctermfg=red
  hi Search guibg=#eac43c guifg=#b5382d
  hi FoldColumn ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi SignColumn ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi hlShowMarks ctermfg=lightgrey ctermbg=none guifg=#bbbbbb guibg=NONE
  hi Error ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi Todo ctermfg=178 ctermbg=none guifg=orange guibg=NONE
  hi SignifySignAdd ctermbg=none ctermfg=107 guibg=NONE guifg=#87af5f
  hi SignifySignDelete ctermbg=none ctermfg=167 guibg=NONE guifg=#df5f5f
  hi SignifySignChange ctermbg=none ctermfg=221 guibg=NONE guifg=#ffdf5f
endif

" Airline
set laststatus=2
set noshowmode
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_detect_modified=0
let g:airline_section_z = '%l:%c %p%%'
let g:airline#extensions#branch#enabled = 1
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



" Local config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

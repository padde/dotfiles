""" VIM-PLUG
if filereadable(expand("~/.vimrc.plugins"))
  source ~/.vimrc.plugins
endif


""" GENERAL SETTINGS

" Enable filetype detection
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Don’t highlight after 1000th column
set synmaxcol=1000

" Show line numbers
set number

" Highlight 80th column
set textwidth=80
set colorcolumn=+0

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

" Set global flag as default for substitution
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

" Don't store data about old buffers
set nohidden

" Don't reset cursor to start of line when moving around
set nostartofline

" Start scrolling before hitting window border
set scrolloff=3
set sidescroll=1
set sidescrolloff=10

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

" Arbitrary selection in visual block mode
set virtualedit+=block

" Use syntax omnicomplete if no ft specific is available
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \	if &omnifunc == "" |
        \	 setlocal omnifunc=syntaxcomplete#Complete |
        \	endif
endif

" Resize splits when the window is resized
au VimResized * :wincmd =


""" CUSTOM MAPPINGS AND COMMANDS

" Map non-breaking space to space
inoremap <A-space> <space>

" C-p and C-n in command mode
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" Clear search
nnoremap <silent> <space> :noh<cr><space>

" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Open in browser
let g:Browser = 'Google Chrome'
set isfname-=? isfname+=?
set isfname-=& isfname+=&
function! PrefixWithHttp(url)
  if filereadable(a:url)
    return a:url
  else
    return substitute(a:url, '\v^(http(s)?:\/\/)?(.*)$', 'http\2://\3', '')
  endif
endfunction
nnoremap <silent> gb :exe('!open -a "'.g:Browser.'" "'.PrefixWithHttp(expand('<cfile>')).'"')<cr><cr>
nnoremap <silent> gB :exe('!open -a "'.g:Browser.'" "'.expand('%').'"')<cr><cr>

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
autocmd! bufwritepost vimrc* source ~/.vimrc

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Reformat JSON
command! FormatJson %!python -m json.tool

" Highlight VCS conflict markers
let g:vcs_conflict_regex = '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
command! NextConflict call search(g:vcs_conflict_regex)
command! PrevConflict call search(g:vcs_conflict_regex, 'b')
exe "match ErrorMsg '" . g:vcs_conflict_regex . "'"
nnoremap <silent> <leader><leader>j :NextConflict<cr>
nnoremap <silent> <leader><leader>k :PrevConflict<cr>

" Prev/next item in quickfix list
map <silent> <leader>cn :cnext<cr>
map <silent> <leader>cp :cprev<cr>


""" PLUGIN SPECIFIC CONFIG

" Ack
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'
  set grepprg=ag\ --nogroup\ --nocolor
endif
nnoremap <leader>a :Ack -i ""<left>
nnoremap <silent>+ *:AckFromSearch<cr>
nnoremap <silent>- #:AckFromSearch<cr>
vnoremap <silent>+ :<c-u>call VisualStarSearchSet('/', 'raw')<cr>:AckFromSearch<cr>
vnoremap <silent>- :<c-u>call VisualStarSearchSet('?', 'raw')<cr>:AckFromSearch<cr>

" Autojump
noremap <leader>j :J<space>

" Ctrl-P
if filereadable(expand("~/.vim/plugged/ctrlp.vim/plugin/ctrlp.vim"))
  let g:ctrlp_show_hidden = 1
  autocmd! bufwritepost * CtrlPClearCache
  autocmd! bufenter * CtrlPClearCache
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --hidden --ignore .git --nocolor -g ""'
    let g:ctrlp_use_caching = 0
  end
end

" Fugitive
function! IsFugitiveBuffer(buffer)
  let bufname = bufname(a:buffer)
  if bufname =~ '^fugitive:' || bufname =~ 'fugitiveblame$'
    return 1
  else
    return 0
  endif
endfunction
function! CloseFugitiveBuffers()
  for b in range(1, bufnr('$'))
    if IsFugitiveBuffer(b)
      exe 'bw ' . b
    endif
  endfor
endfunction
nnoremap <leader>gc :silent! call CloseFugitiveBuffers()<cr>

" Gist
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Gundo
map <silent> <leader>u :silent! GundoToggle<cr>

" Indent guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd cterm=none gui=NONE
autocmd VimEnter,Colorscheme * :hi link IndentGuidesEven Folded

" NERDtree
let g:NERDTreeChDirMode=2
" These mappings would interfere with vim-tmux-navigator
let g:NERDTreeMapJumpNextSibling=''
let g:NERDTreeMapJumpPrevSibling=''
nnoremap <silent> <leader>d :NERDTreeToggle<cr>
nnoremap <silent> <leader><leader>d :NERDTreeFind<cr>

" Preserve EOL
let g:PreserveNoEOL = 1
let g:PreserveNoEOL_Function = function('PreserveNoEOL#Internal#Preserve')

" Seeing is believing
let g:xmpfilter_cmd = "seeing_is_believing"
autocmd FileType ruby nmap <buffer> <leader>sm <Plug>(seeing_is_believing-mark)
autocmd FileType ruby xmap <buffer> <leader>sm <Plug>(seeing_is_believing-mark)
autocmd FileType ruby imap <buffer> <leader>sm <Plug>(seeing_is_believing-mark)
autocmd FileType ruby nmap <buffer> <leader>sc <Plug>(seeing_is_believing-clean)
autocmd FileType ruby xmap <buffer> <leader>sc <Plug>(seeing_is_believing-clean)
autocmd FileType ruby imap <buffer> <leader>sc <Plug>(seeing_is_believing-clean)
autocmd FileType ruby nmap <buffer> <leader>sr <Plug>(seeing_is_believing-run)
autocmd FileType ruby xmap <buffer> <leader>sr <Plug>(seeing_is_believing-run)
autocmd FileType ruby imap <buffer> <leader>sr <Plug>(seeing_is_believing-run)
autocmd FileType ruby nmap <buffer> <leader>sR <Plug>(seeing_is_believing-run_-x)
autocmd FileType ruby xmap <buffer> <leader>sR <Plug>(seeing_is_believing-run_-x)
autocmd FileType ruby imap <buffer> <leader>sR <Plug>(seeing_is_believing-run_-x)

" Signify
let g:signify_disable_by_default=1

" Syntastic
let g:syntastic_error_symbol='●'
let g:syntastic_warning_symbol='■'
let g:syntastic_style_error_symbol='○'
let g:syntastic_style_warning_symbol='□'
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_mode_map = {'mode': 'passive'}

" Tmux
let g:no_turbux_mappings = 1
map <leader>t <Plug>SendTestToTmux
map <leader><leader>t <Plug>SendFocusedTestToTmux
map <Leader>T :call RunAllSpecs()<CR>

" Tmux + RSpec + Spring
function! SetRspecCommand()
  " q - exit tmux's visual mode
  " C-u - clear existing input
  " C-c (twice) - abort currently running spec
  let common_prefix = 'q'
  call system('bundle show spring')
  if !v:shell_error
    let common_prefix = common_prefix.'spring '
  endif
  let g:turbux_command_prefix = common_prefix
  let g:rspec_command = 'call VimuxRunCommand("'.common_prefix.'rspec {spec}\n")'
endfunction
call SetRspecCommand()

" ZoomWin
nnoremap <silent> <C-w>z :ZoomWin<cr>


""" FANCYNESS

" Colors
set background=dark
if filereadable(expand("~/.vim/plugged/base16-vim/colors/base16-default.vim"))
  colorscheme base16-default
end

" Hightlight current line
set cursorline

" Invisibles
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<,nbsp:␣

" Splits
set fillchars+=vert:│
hi VertSplit ctermbg=none ctermfg=10 guibg=NONE guifg=#202020

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
let g:airline_section_c = '%F'
let g:airline_mode_map = {
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'v'  : 'V',
  \ 'V'  : 'VL',
  \ 'c'  : 'CMD',
  \ '' : 'VB',
  \ }


""" LOCAL CONFIG

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

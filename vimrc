" Enter the 21st century
set nocompatible

call plug#begin('~/.vim/plugged')

" Hide startup message
set shortmess=atI

" Global dependencies
Plug 'tpope/vim-repeat'

" Nobody likes \ as leader!
let mapleader = ","

" Enable syntax highlighting
syntax on
Plug 'sheerun/vim-polyglot'

" Line numbers
set number

" Highlight 80th column
set textwidth=80
set colorcolumn=+0

" Indentation
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
filetype indent on

" Soft wrap
set wrap
set linebreak
set breakindent

" Autocomplete commands
set wildmenu
set wildmode=list:longest,full

" Share clipboard with OS
set clipboard+=unnamed

" Enable mouse
set mouse=a
if has("mouse_sgr")
  set ttymouse=sgr
elseif has("mouse_xterm")
  set ttymouse=xterm2
end

" TMUX
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'sjl/vitality.vim'
au VimResized * :wincmd = " Resize splits when the window is resized

" Use UTF-8
set nobomb
set encoding=utf-8
set fileencoding=utf-8

" Reload changes if detected
set autoread

" Split direction
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


" Autodetect indentation settings
filetype indent on
Plug 'ciaranm/detectindent'

" Indent guides
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
au VimEnter,ColorScheme * :hi IndentGuidesOdd cterm=none gui=NONE
au VimEnter,ColorScheme * :hi link IndentGuidesEven Folded

" Show invisible characters
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<,nbsp:␣
set nolist " but turn off by default

" Preserve EOL
Plug 'vim-scripts/PreserveNoEOL'
let g:PreserveNoEOL = 1
let g:PreserveNoEOL_Function = function('PreserveNoEOL#Internal#Preserve')

" Load filetype specific config
filetype plugin on

" Buffer search
set hlsearch   " Search highlighting
set incsearch  " Highlight search as you type
set ignorecase " Ignore case in search...
set smartcase  " ... except when pattern contains uppercase characters
set gdefault   " Search globally by default

" Clear search
nnoremap <silent> <space> :noh<cr><space>

" Project search
Plug 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'
  set grepprg=ag\ --nogroup\ --nocolor
endif
nnoremap <leader>a :Ack -i ""<left>
nnoremap <silent>+ *:AckFromSearch<cr>
nnoremap <silent>- #:AckFromSearch<cr>
Plug 'bronson/vim-visual-star-search'
vnoremap <silent>+ :<c-u>call VisualStarSearchSet('/', 'raw')<cr>:AckFromSearch<cr>
vnoremap <silent>- :<c-u>call VisualStarSearchSet('?', 'raw')<cr>:AckFromSearch<cr>

" File search
Plug 'kien/ctrlp.vim'
let g:ctrlp_show_hidden = 1
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --hidden --ignore .git --nocolor -g ""'
  let g:ctrlp_use_caching = 0
end

" File explorer
Plug 'scrooloose/nerdtree'
let g:NERDTreeChDirMode=2
let g:NERDTreeCascadeSingleChildDir=0
" These mappings would interfere with vim-tmux-navigator
let g:NERDTreeMapJumpNextSibling=''
let g:NERDTreeMapJumpPrevSibling=''
let g:NERDTreeMinimalUI=1
nnoremap <silent> <leader>d :NERDTreeToggle<cr>
nnoremap <silent> <leader><leader>d :NERDTreeFind<cr>

" Make directory on the fly with :e
Plug 'pbrisbin/vim-mkdir'

" Auto-continue comments
set formatoptions=croql
silent! set formatoptions+=j

" Undo
set undofile
set undolevels=1000
set undoreload=10000
Plug 'sjl/gundo.vim'

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

" Use syntax omnicomplete if no ft specific is available
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif
endif

" Automatically insert `end`
Plug 'tpope/vim-endwise'

" Comments
Plug 'tpope/vim-commentary'

" Surround
Plug 'tpope/vim-surround'

" Exchange regions
Plug 'tommcdo/vim-exchange'

" Format tabular data
Plug 'godlygeek/tabular'

" Map non-breaking space to space
inoremap <A-space> <space>

" C-p and C-n in command mode
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" Select last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Open in browser
let g:Browser = 'com.google.Chrome'
set isfname-=? isfname+=?
set isfname-=& isfname+=&
function! OpenInBrowser(string)
  let fileOrUrl = substitute(a:string ,  "\\v(.*[\"])([^\"]+)([\"].*)", '\2', '')
  let fileOrUrl = substitute(fileOrUrl, "\\v(.*[\'])([^\']+)([\'].*)", '\2', '')
  if !filereadable(fileOrUrl)
    let fileOrUrl = substitute(fileOrUrl, '\v^(http(s)?:\/\/)?(.*)$', 'http\2://\3', '')
  endif
  echo system("open -b '".g:Browser."' '".fileOrUrl."'")
endfunction
nnoremap <silent> gb :call OpenInBrowser(expand('<cWORD>'))<cr>
nnoremap <silent> gB :call OpenInBrowser(expand('%:p'))<cr>

" Write with super user permissions
command! Wsudo :w !sudo tee %

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Higlight Git conflict markers
match ErrorMsg '\v^[<=>]{7}.*$'
noremap <silent> <leader>j /\v^[<=>]{7}<cr>
noremap <silent> <leader>k r\v^[<=>]{7}<cr>

" Go to prev/next item in quickfix list
nnoremap <silent> <leader>n :silent cnext<cr>
nnoremap <silent> <leader>N :silent cprev<cr>
nnoremap <silent> <leader>fn :silent cfnext<cr>
nnoremap <silent> <leader>fN :silent cfprev<cr>

" Delete all hidden buffers
function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! DeleteHiddenBuffers :call DeleteHiddenBuffers()

" Vim-Test
Plug 'janko-m/vim-test'
function! SimpleVimuxStrategy(cmd) abort
  call VimuxRunCommand(a:cmd)
endfunction
let g:test#custom_strategies = {'simple_vimux': function('SimpleVimuxStrategy')}
let g:test#strategy = 'simple_vimux'
let g:test#ruby#rspec#executable = 'rspec'
try
  " Hacky hack to enable :TestSuite when no test was run yet
  let spec_path = systemlist('git rev-parse --show-toplevel')[0] . '/spec/'
  let all_specs = split(globpath(spec_path, '**/*_spec.rb'), '\n')
  let g:test#last_position={'file': all_specs[0], 'col': 1, 'line': 1}
  let g:test#last_command=g:test#ruby#rspec#executable
catch
endtry
nmap <silent> <leader>tt :TestNearest<cr>
nmap <silent> <leader>tf :TestFile<cr>
nmap <silent> <leader>ts :TestSuite<cr>
nmap <silent> <leader>tl :TestLast<cr>
nmap <silent> <leader>tg :TestVisit<cr>
let test#runners = {'Elixir': ['Exercism']}

" Neomake
Plug 'neomake/neomake'
autocmd! BufWritePost * silent! Neomake

" Ruby/Rails
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rbenv'
Plug 'joker1007/vim-ruby-heredoc-syntax'

" Elixir/Phoenix
Plug 'spiegela/vimix'
Plug 'c-brenn/phoenix.vim'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'slashmili/alchemist.vim'
let g:alchemist#elixir_erlang_src = "/usr/local/share/src"

" Markdown
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1

" Git
Plug 'tpope/vim-fugitive'
autocmd User fugitive command! -bar -buffer -nargs=* Gshame :Gblame -w -M -C <args>

" Gist
Plug 'mattn/webapi-vim' " required by gist-vim
Plug 'mattn/gist-vim'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1

" Disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" https://github.com/vim/vim/issues/804#issuecomment-225085911
if &term =~ '256color'
  set t_ut=
endif

" Color scheme
set termguicolors
set background=dark
Plug 'chriskempson/base16-vim'
function! s:SetColorScheme()
  if filereadable(expand("~/.vim/plugged/base16-vim/colors/base16-default-dark.vim"))
    colorscheme base16-default-dark
  end
endfunction
au VimEnter * call s:SetColorScheme()
function! s:SimpleGutterColors()
  hi VertSplit ctermbg=none guibg=NONE
  hi LineNr ctermbg=none guibg=NONE
  hi FoldColumn ctermbg=none guibg=NONE
  hi SignColumn ctermbg=none guibg=NONE
endfunction
au VimEnter,ColorScheme * call s:SimpleGutterColors()

" Nicer looking splits
set fillchars+=vert:│

" Statusline
function! StatusLineMode()
  let mapping = {
  \ 'n' : 'N',
  \ 'v' : 'V',
  \ 'V' : 'VL',
  \ '' : 'VB',
  \ 'i' : 'I',
  \ 'R' : 'R',
  \ 'Rv' : 'VR',
  \}
  return get(mapping, mode(1), toupper(mode(1)))
endfunction
function! StatusLineModified()
  return &modified==1 ? "*" : ""
endfunction
function! SetStatusLineColors()
  hi! link StatusLine Visual
  hi! link User1 Folded
endfunction
au VimEnter,ColorScheme * call SetStatusLineColors()
set laststatus=2
set noshowmode
set statusline=
set statusline+=%(%0*\ %{StatusLineMode()}\ %)
set statusline+=%(%1*\ %t%{StatusLineModified()}\ %)
set statusline+=%1*%=
set statusline+=%(%1*\ %{&ft}\ %)
set statusline+=%(%0*\ %l:%v\ %p%%\ %)

" Show syntax highlighting groups for word under cursor
nmap <leader>z :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Show unicode codepoint under cursor with `ga`
Plug 'tpope/vim-characterize'

" Hex editor
Plug 'fidian/hexmode'

" Local/experimental configuration
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

call plug#end()

" Load project specific .vimrc files
set exrc
set secure

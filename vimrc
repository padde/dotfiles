""" PLUGINS

call plug#begin('~/.vim/plugged')

" Dependencies required by multiple plugins
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'

" TMUX integration
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" File management
Plug 'scrooloose/nerdtree'
Plug 'pbrisbin/vim-mkdir'
Plug 'padde/jump.vim'

" Search
Plug 'bronson/vim-visual-star-search'
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'
Plug 'sjl/vitality.vim'

" Smart input
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tommcdo/vim-exchange'
Plug 'terryma/vim-multiple-cursors'
Plug 'ciaranm/detectindent'
Plug 'vim-scripts/PreserveNoEOL'
Plug 'godlygeek/tabular'

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-underscore'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-surround'

" Version control
Plug 'tpope/vim-fugitive'
Plug 'phleet/vim-mercenary'
Plug 'ludovicchabant/vim-lawrencium'

" Syntax
Plug 'othree/html5.vim'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'kchmck/vim-coffee-script'
Plug 'groenewege/vim-less'
Plug 'ap/vim-css-color'

" Testing
Plug 'janko-m/vim-test'

" Ruby development
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rbenv'
Plug 'vim-ruby/vim-ruby'
Plug 't9md/vim-ruby-xmpfilter'

" Elixir development
Plug 'elixir-lang/vim-elixir'
Plug 'spiegela/vimix'

" Little helpers
Plug 'tpope/vim-characterize'
Plug 'mattn/webapi-vim' " required by gist-vim
Plug 'mattn/gist-vim'
Plug 'sjl/gundo.vim'
Plug 'fidian/hexmode'

" Fancyness
Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'

if filereadable(expand("~/.vimrc.plugins.local"))
  source ~/.vimrc.plugins.local
endif

call plug#end()



""" GENERAL SETTINGS

" Enable filetype detection
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Don’t highlight after 350th column
set synmaxcol=350

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

set cryptmethod=blowfish2

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

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Reformat JSON
command! FormatJson %!python -m json.tool

" Reformat SQL
" pip install sqlparse
command! FormatSQL %!sqlformat -r - -k upper -i lower

" Reformat HTML/XML
" brew install tidy-html5
command! FormatHTML :%!tidy -q -i -w 0 --show-errors 0 --tidy-mark 0
command! FormatXML :%!tidy -q -i -w 0 --show-errors 0 --tidy-mark 0 -xml

" VCS conflict markers
match ErrorMsg "^\(<\|=\|>\)\{7\}\([^=].\+\)\?$"
noremap <silent> <leader><leader>j /\V\^\(=======\\|<<<<<<<\\|>>>>>>>\)<cr>
noremap <silent> <leader><leader>k /\V\^\(=======\\|<<<<<<<\\|>>>>>>>\)<cr>

" Prev/next item in quickfix list
map <silent> <leader>n :silent cnext<cr>
map <silent> <leader>N :silent cprev<cr>



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

" Ctrl-P
let g:ctrlp_show_hidden = 1
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --hidden --ignore .git --nocolor -g ""'
  let g:ctrlp_use_caching = 0
end

" Fugitive
autocmd User fugitive command! -bar -buffer -nargs=* Gshame :Gblame -w -M -C <args>

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

" Vim-Test
function! SimpleVimuxStrategy(cmd) abort
  call VimuxRunCommand(a:cmd)
endfunction
let g:test#custom_strategies = {'simple_vimux': function('SimpleVimuxStrategy')}
let g:test#strategy = 'simple_vimux'
let g:test#ruby#rspec#executable = 'bundle exec rspec'
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



""" FANCYNESS

" Colors
set background=dark
if filereadable(expand("~/.vim/plugged/base16-vim/colors/base16-default.vim"))
  colorscheme base16-default
end
function! SimpleGutterColors()
  hi VertSplit ctermbg=none guibg=NONE
  hi LineNr ctermbg=none guibg=NONE
  hi FoldColumn ctermbg=none guibg=NONE
  hi SignColumn ctermbg=none guibg=NONE
endfunction
au ColorScheme * call SimpleGutterColors()
call SimpleGutterColors()

" Hightlight current line
set cursorline

" Invisibles
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<,nbsp:␣

" Splits
set fillchars+=vert:│

" Airline
set laststatus=2
set noshowmode
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_b = '%{substitute(getcwd(), ".*\/", "", "g")}'
let g:airline_section_c = '%{substitute(expand("%"), expand("~"), "~", "g")}'
let g:airline_section_z = '%l:%c %p%%'
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

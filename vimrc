" Enter the 21st century
set nocompatible

call plug#begin('~/.vim/plugged')



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Hide startup message
set shortmess=atIO

" Nobody likes \ as leader!
let mapleader = ","

" Enable syntax highlighting
syntax on
set synmaxcol=200

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

" Backspace in insert mode
set backspace=indent,eol,start

" Enable mouse
set mouse=a
if has("mouse_sgr")
  set ttymouse=sgr
elseif has("mouse_xterm")
  set ttymouse=xterm2
end

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

" Show invisible characters
set listchars=tab:▸\ ,eol:¬,trail:·,extends:>,precedes:<,nbsp:␣
set list

" Load filetype specific config
filetype plugin on

" Buffer search
set hlsearch   " Search highlighting
set incsearch  " Highlight search as you type

" Project search
if executable('rg')
  set grepprg=rg\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
endif

function! Grep(pattern)
  let flags = ' '
  if &ignorecase
    let flags = flags . '-i ' " --ignore-case
  endif
  if &smartcase
    let flags = flags . '-S ' " --smart-case
  endif
  silent exe 'grep! ' . flags . a:pattern
  cwindow
  redraw!
endfunction

command! -nargs=* -complete=file Grep :call Grep(<q-args>)
nnoremap <leader>a :Grep ""<left>
xnoremap <leader>a :<C-u>Grep ""<left>
au Filetype qf nnoremap <buffer> o <cr>
au Filetype qf nnoremap <buffer> go <cr><C-w><C-w>

" Visual search
function! GetSelection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! SetSearchFromSelection(additionalEscapeChars)
  let pat = GetSelection()
  let pat = escape(pat, '\'.a:additionalEscapeChars)
  let pat = substitute(pat, "\n", "\\\\n", 'g')
  let @/ = '\V'.pat
endfunction

function! ExecuteCmdWithHistory(cmd)
  call histadd("cmd", a:cmd)
  execute a:cmd
endfunction

function! EscapePattern(pattern)
  let pattern = a:pattern
  let pattern = substitute(pattern, '\([#%]\)', '\\\\\1', 'g')
  let pattern = shellescape(pattern)
  return pattern
endfunction

function! ProjectSearch(pattern, wordRegexp)
  let flags = '-F ' " --fixed-strings
  if a:wordRegexp
    let flags = flags . '-w ' " --word-regexp
  endif
  call ExecuteCmdWithHistory('Grep '.flags.EscapePattern(a:pattern))
endfunction

xnoremap * :<C-u>call SetSearchFromSelection('/')<cr>/<C-r>=@/<cr><cr>
xnoremap # :<C-u>call SetSearchFromSelection('?')<cr>?<C-r>=@/<cr><cr>
xnoremap + :<C-u>call SetSearchFromSelection('/')<cr>/<C-r>=@/<cr><cr>:call ProjectSearch(GetSelection(), 0)<cr>
nnoremap + *:call ProjectSearch(expand('<cword>'), 1)<cr>

" Auto-continue comments
set formatoptions=croql
silent! set formatoptions+=j

" Command line history
set history=10000

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

" Color scheme
set termguicolors
set background=dark

Plug 'chriskempson/base16-vim'
au VimEnter * colorscheme base16-default-dark
au VimEnter,ColorScheme *
      \ hi VertSplit ctermbg=none guibg=NONE |
      \ hi LineNr ctermbg=none guibg=NONE |
      \ hi FoldColumn ctermbg=none guibg=NONE |
      \ hi SignColumn ctermbg=none guibg=NONE |
      \ hi SpellBad term=underline ctermbg=none cterm=undercurl |
      \ hi SpellCap term=underline ctermbg=none cterm=undercurl |
      \ hi SpellRare term=underline ctermbg=none cterm=undercurl |
      \ hi SpellLocal term=underline ctermbg=none cterm=undercurl

" Nicer looking splits
set fillchars+=vert:│

" Show statusline
set laststatus=2

" Map non-breaking space to space
inoremap <A-space> <space>

" Map C-p/n to up/down in command mode
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" Map C-a to start of line in command mode
cnoremap <c-a> <c-b>

" Select last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Write with super user permissions
command! Wsudo :w !sudo tee %

" Start fresh
command! Fresh :bufdo bd | NERDTree

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Higlight Git conflict markers
match ErrorMsg '\v^[<=>]{7}.*$'
noremap <silent> <leader>j /\v^[<=>]{7}<cr>
noremap <silent> <leader>k r\v^[<=>]{7}<cr>

" Go to prev/next item in quickfix list
nnoremap <silent> <c-n> :silent cnext \| silent cc<cr>
nnoremap <silent> <c-b> :silent cprev \| silent cc<cr>

" Show syntax highlighting groups for word under cursor
nmap <leader>z :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Collect results of command execution
command! -nargs=+ C Collect<args>
command! -nargs=+ Collect
      \ let pos = getpos('.')
      \ | let tmp = ''
      \ | g<args>
      \ | let tmp .= @"
      \ | let @* = tmp
      \ | call setpos('.', pos)



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GLOBAL PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Global dependencies
Plug 'tpope/vim-repeat'

" File search
Plug 'kien/ctrlp.vim'
let g:ctrlp_show_hidden = 1

let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)|_build|deps|priv/static|tmp|vendor|log|public|node_modules$',
      \ }
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --hidden --ignore-file=<(echo .git) --color=never --glob=""'
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
let g:NERDTreeMinimalMenu=1
nnoremap <silent> <leader>d :NERDTreeToggle<cr>
nnoremap <silent> <leader><leader>d :NERDTreeFind<cr>

" Undo
set undofile
set undolevels=1000
set undoreload=10000
Plug 'sjl/gundo.vim'
let g:gundo_prefer_python3 = 1
nnoremap <leader>u :silent! GundoToggle<cr>

" Open quickfix items in split/tab
Plug 'yssl/QFEnter'
let g:qfenter_enable_autoquickfix = 0
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" Delete all hidden buffers
function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction
command! DeleteHiddenBuffers :call DeleteHiddenBuffers()

" Make directory on the fly with :e
Plug 'pbrisbin/vim-mkdir'

" Autojump
Plug 'padde/jump.vim'

" Open file at line/char
Plug 'kopischke/vim-fetch'

" UNIX tools
Plug 'tpope/vim-eunuch'

" Automatically insert `end`
Plug 'tpope/vim-endwise'

" Comments
Plug 'tpope/vim-commentary'

" Surround
Plug 'tpope/vim-surround'

" Exchange regions
Plug 'tommcdo/vim-exchange'

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
nnoremap <silent> <leader>tt :TestNearest<cr>
nnoremap <silent> <leader>tf :TestFile<cr>
nnoremap <silent> <leader>ts :TestSuite<cr>
nnoremap <silent> <leader>tl :TestLast<cr>
nnoremap <silent> <leader>gl :TestVisit<cr>
let test#runners = {'Elixir': ['Exercism']}

" Elixir umbrella test runner
" https://github.com/wojtekmach/dotfiles/blob/92f8607b76bb17ff5b138410a21d3ebedf0b2d37/vim/.vimrc#L131:L144
function! ElixirUmbrellaTransform(cmd) abort
  if match(a:cmd, 'apps/') != -1
    return substitute(a:cmd, 'mix test apps/\([^/]*/\)\(.*\)', '(cd apps/\1 \&\& mix test \2)', '')
  else
    return a:cmd
  end
endfunction
let g:test#custom_transformations = {'elixir_umbrella': function('ElixirUmbrellaTransform')}
let g:test#transformation = 'elixir_umbrella'

" ALE Linter
Plug 'w0rp/ale'
set signcolumn=yes
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_linters = {
      \ 'elixir': []
      \ }
let g:ale_fixers = {
      \ 'javascript': ['eslint']
      \ }

" ANSI escape codes
Plug 'powerman/vim-plugin-AnsiEsc'

" Git
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
autocmd User fugitive command! -bar -buffer -nargs=* Gshame :Gblame -w -M -C <args>
nnoremap <leader>g :Gshame<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete

" Github
Plug 'tpope/vim-rhubarb'

" Gist
Plug 'mattn/webapi-vim' " required by gist-vim
Plug 'mattn/gist-vim'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1

" Show unicode codepoint under cursor with `ga`
Plug 'tpope/vim-characterize'

" Hex editor
Plug 'fidian/hexmode'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LANGUAGE SPECIFIC PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Rust
Plug 'rust-lang/rust.vim'
Plug 'wellbredgrapefruit/tomdoc.vim'
Plug 'cespare/vim-toml'

" HTML
Plug 'othree/html5.vim'

" CSS, SASS, SCSS, LESS
Plug 'cakebaker/scss-syntax.vim'
Plug 'groenewege/vim-less'

" HTML, HAML and preprocessors
Plug 'mustache/vim-mustache-handlebars'
Plug 'sheerun/vim-haml'
Plug 'mattn/emmet-vim'
imap <C-y><C-y> <C-y>,
imap <C-y><CR> <C-y>,<CR><C-o>O
let g:user_emmet_settings = {
      \   'javascript.jsx' : {'extends' : 'jsx'}
      \ }

" JavaScript, CoffeeScript, JSX, React.js, Vue.js
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0
Plug 'posva/vim-vue'

" Docker
Plug 'docker/docker', {'rtp': '/contrib/syntax/vim/'}

" Go
Plug 'fatih/vim-go'

" LaTeX
Plug 'LaTeX-Box-Team/LaTeX-Box'

" Lua
Plug 'tbastos/vim-lua'

" Markdown
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_new_list_item_indent=0

" Nginx
Plug 'chr4/nginx.vim'

" Tmux
Plug 'keith/tmux.vim'

" Postgres
Plug 'exu/pgsql.vim'

" Terraform
Plug 'hashivim/vim-terraform'
au FileType terraform let &l:formatprg="terraform fmt -"
au FileType terraform setlocal commentstring=#%s

" Apache
au FileType apache setlocal commentstring=#%s

" TMUX
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'sjl/vitality.vim'
au VimResized * :wincmd = " Resize splits when the window is resized

" Ruby/Rails
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'sheerun/rspec.vim'
Plug 'joker1007/vim-ruby-heredoc-syntax'

" Elixir/Phoenix
Plug 'elixir-editors/vim-elixir'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'slashmili/alchemist.vim'
let g:alchemist#elixir_erlang_src = "/usr/local/share/src"
if exists("$COMPILE_BASEPATH")
  let g:alchemist_compile_basepath = $COMPILE_BASEPATH
endif
Plug 'slime-lang/vim-slime-syntax'
au FileType slime setlocal commentstring=//%s
Plug 'mhinz/vim-mix-format'
" let g:mix_format_on_save = 1
let g:mix_format_options = '--check-equivalent'
let g:mix_format_silent_errors = 1
nnoremap <leader>mf :MixFormat<cr>

" Direnv

" Markdown
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1

" Local/experimental configuration
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

call plug#end()

" Load project specific .vimrc files
set exrc
set secure

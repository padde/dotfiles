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
set synmaxcol=5000

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
set nowrap
set linebreak
set breakindent

" Autocomplete commands
set wildmenu
set wildmode=list:longest,full

" Share clipboard with OS
set clipboard+=unnamed

" Backspace in insert mode
set backspace=indent,eol,start

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
nnoremap <leader>a :Grep -- ""<left>
xnoremap <leader>a :<C-u>Grep -- ""<left>
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
  let @/ = '\V'.EscapeSearch(GetSelection(), a:additionalEscapeChars)
endfunction

function! EscapeSearch(string, additionalEscapeChars)
  let pat = escape(a:string, '\'.a:additionalEscapeChars)
  return substitute(pat, "\n", "\\\\n", 'g')
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
  call ExecuteCmdWithHistory('Grep '.flags.' -- '.EscapePattern(a:pattern))
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
Plug 'chriskempson/base16-vim'
set termguicolors

" Set color scheme based on light/dark mode
command! Dark set background=dark | colorscheme base16-default-dark
command! Light set background=light | colorscheme base16-default-light

if has('jobs') || has('nvim')
  function! SetColorSchemeReceive(job_id, data, event)
    if join(a:data) =~ '^Dark' && &background != 'dark'
      Dark
    elseif join(a:data) =~ '^Light' && &background != 'light'
      Light
    endif
  endfunction

  function! SetColorscheme(...)
    call jobstart([$HOME.'/.dotfiles/bin/os_appearance'], {'on_stdout': 'SetColorSchemeReceive'})
  endfunction

  autocmd VimEnter * set background= | call SetColorSchemeReceive(0, systemlist([$HOME.'/.dotfiles/bin/os_appearance']), 0)

  if exists('##OSAppearanceChanged')
    autocmd OSAppearanceChanged * call SetColorscheme()
  elseif has('timers')
    call timer_start(1000, 'SetColorscheme', {'repeat': -1})
  end
else
  if system($HOME.'/.dotfiles/bin/os_appearance') =~ '^Dark'
    autocmd VimEnter * :Dark
  else
    autocmd VimEnter * :Light
  endif
endif

" Reduce colors in some areas
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

" Paste last yanked text
noremap <leader>p "0p

" Write with super user permissions
command! Wsudo :w !sudo tee %

" Start fresh
command! Fresh :bufdo bd | NERDTree

" Remove trailing whitespace including non-breaking spaces
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
nnoremap <leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <leader>rt :RemoveTrailingWhitespace<CR>

" Hard wrap current line/selected lines to textwidth
command! -range=1 HardWrap exe "<line1>,<line2>!fold -w".&tw." | tr -d '^M'"
nnoremap <leader>F :HardWrap<CR>
vnoremap <leader>F :HardWrap<CR>

" Higlight Git conflict markers
match ErrorMsg '\v^[<=>]{7}.*$'
noremap <silent> <leader>j /\v^[<=>]{7}<cr>
noremap <silent> <leader>k ?\v^[<=>]{7}<cr>

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
let g:ctrlp_root_markers = ['mix.exs']
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)|_build|deps|priv/static|tmp|vendor|log|public|node_modules$',
      \ }
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --hidden --ignore-file=<(echo .git) --color=never --glob=""'
  let g:ctrlp_use_caching = 0
end

" File explorer
Plug 'scrooloose/nerdtree'
let NERDTreeCascadeSingleChildDir=0
let NERDTreeMinimalUI=1
let NERDTreeMinimalMenu=1
" These mappings would interfere with vim-tmux-navigator
let NERDTreeMapJumpNextSibling=''
let NERDTreeMapJumpPrevSibling=''
nnoremap <silent> <leader>d :NERDTreeToggle<cr>
nnoremap <silent> <leader><leader>d :NERDTreeRefreshRoot \| NERDTreeFind<cr>
let NERDTreeRespectWildIgnore=1
let NERDTreeIgnore=['\~$', '__pycache__$[[dir]]']

" Undo
set undofile
set undolevels=1000
set undoreload=10000
Plug 'simnalamburt/vim-mundo'
let g:mundo_prefer_python3 = 1
nnoremap <leader>u :silent! MundoToggle<cr>

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

" Edit file under cursor, like gf but creates files that don't exist yet
nnoremap GF :e <cfile><CR>

" Edit git object under cursor
nnoremap GG :Gedit <cword><CR>

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

" Split single-line statements gS, join multi-line blocks gJ
Plug 'AndrewRadev/splitjoin.vim'

" Replace all variants of a word
Plug 'tpope/vim-abolish'

" Exchange regions
Plug 'tommcdo/vim-exchange'

" Vim-Test
Plug 'vim-test/vim-test'
nnoremap <silent> <leader>tt :TestNearest<cr>
nnoremap <silent> <leader>tf :TestFile<cr>
nnoremap <silent> <leader>ts :TestSuite<cr>
nnoremap <silent> <leader>tl :TestLast<cr>
nnoremap <silent> <leader>tv :TestVisit<cr>

" run in vimux with no additional magic (clear screen, echo command, ...)
function! SimpleVimuxStrategy(cmd) abort
  call VimuxRunCommand(a:cmd)
endfunction
let test#custom_strategies = {'simple_vimux': function('SimpleVimuxStrategy')}
let test#strategy = 'simple_vimux'

" run rspec without bundle exec, use env/binstubs instead
let test#ruby#rspec#executable = 'rspec -fdoc'

" use custom elixir exercism runner, see vim/autoload/test/elixir/exercism.vim
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
let test#custom_transformations = {'elixir_umbrella': function('ElixirUmbrellaTransform')}
let test#transformation = 'elixir_umbrella'

" disable watch mode for react-scripts
let test#javascript#reactscripts#options = '--watchAll=false'

" ALE Linter
Plug 'dense-analysis/ale'
set signcolumn=yes
let g:ale_sign_column_always = 1
let g:ale_sign_info = 'i '
let g:ale_sign_warning = '!'
let g:ale_sign_error = 'X'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_linters = {
      \ 'elixir': []
      \ }
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \ 'css': ['stylelint'],
      \ 'scss': ['stylelint'],
      \ 'html': ['prettier'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'ruby': ['rubocop']
      \ }
let g:ale_pattern_options = {
      \ 'db\/schema\.rb$': {'ale_fixers': []},
      \ 'db\/migrate\/.*\.rb$': {'ale_fixers': []}
      \ }
nnoremap <leader>f :ALEFix<cr>
command! ALEFixDisable :let b:ale_fix_on_save=0
command! ALEFixEnable :unlet b:ale_fix_on_save

" ANSI escape codes
Plug 'powerman/vim-plugin-AnsiEsc'

" Git
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
function! ToggleGshame() abort
  let closing = 0
  for buffer in tabpagebuflist()
    if index(['fugitiveblame', 'git'], getbufvar(buffer, '&filetype')) >= 0
      exec 'bdelete '.buffer
      let closing = 1
    endif
  endfor
  if closing
    if expand('%') =~ '^fugitive://'
      Gedit
    endif
  else
    Git shame
  endif
endfunction
nnoremap <silent> <leader>g :call ToggleGshame()<cr>
command! -nargs=* Gprdiff :exec 'Gdiff '.system('git pr-base').' <args>'
autocmd BufReadPost fugitive://* set bufhidden=delete

" Gitlab
Plug 'shumphrey/fugitive-gitlab.vim'

" Github
Plug 'tpope/vim-rhubarb'

" Azure DevOps
Plug 'cedarbaum/fugitive-azure-devops.vim'

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

" JavaScript, TypeScript, CoffeeScript, JSX, React.js, Vue.js
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
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
Plug 'lifepillar/pgsql.vim'

" Terraform
Plug 'hashivim/vim-terraform'

" TMUX
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'sjl/vitality.vim'
au VimResized * :wincmd = " Resize splits when the window is resized

" Ruby/Rails
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
nnoremap <leader>. :A<cr>
nnoremap <leader>> :R<cr>
Plug 'tpope/vim-bundler'
Plug 'sheerun/rspec.vim'
Plug 'joker1007/vim-ruby-heredoc-syntax'
let g:ruby_heredoc_syntax_filetypes = {
  \ "javascript" : {
  \   "start" : '\(JS\|JAVASCRIPT\)',
  \},
\}
autocmd BufNewFile *.rb 0r ~/.vim/skeletons/ruby.rb | norm G

" Elixir/Phoenix
Plug 'elixir-editors/vim-elixir'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'slashmili/alchemist.vim'
let g:alchemist#elixir_erlang_src = "/usr/local/share/src"
if exists("$COMPILE_BASEPATH")
  let g:alchemist_compile_basepath = $COMPILE_BASEPATH
endif
Plug 'slime-lang/vim-slime-syntax'
Plug 'mhinz/vim-mix-format'
let g:mix_format_on_save = 1
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

" Base64 encode/decode
Plug 'christianrondeau/vim-base64'

call plug#end()

" Load project specific .vimrc files
set exrc
set secure

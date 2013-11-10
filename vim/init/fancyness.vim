" Font
set guifont=Menlo\ Regular:h12

" Color scheme
" colorscheme solarized
colorscheme railscasts

" Show invisibles as in Text Mate (with improvements)
set listchars=tab:\ \ ,eol:¬,trail:·,extends:>,precedes:<
set list

" Hightlight current line in gui
set cursorline

" Hide menu bar in MacVim
if has('gui_running')
  set guioptions=egmrt
endif

if g:colors_name == 'railscasts'
  " Search results
  hi Search cterm=NONE ctermbg=238 ctermfg=NONE
  hi Search guibg=#eac43c guifg=#b5382d

  " Folds
  hi FoldColumn ctermfg=red ctermbg=none guifg=red guibg=NONE

  " Signs
  hi SignColumn ctermfg=red ctermbg=none guifg=red guibg=NONE

  " Marks
  hi hlShowMarks ctermfg=lightgrey ctermbg=none guifg=#bbbbbb guibg=NONE

  " Error, Todo, Syntastic symbols
  hi Error ctermfg=red ctermbg=none guifg=red guibg=NONE
  hi Todo ctermfg=178 ctermbg=none guifg=orange guibg=NONE
endif

" Airline
set laststatus=2
set noshowmode

let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_detect_modified=0

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

let g:airline_section_z = '%l:%c %p%%'

let g:airline#extensions#branch#enabled = 1

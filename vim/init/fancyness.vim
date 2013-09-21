" Font
set guifont=Menlo\ Regular:h12

" Color scheme
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

" Search results
hi Search cterm=NONE ctermbg=yellow ctermfg=darkred
hi Search guibg=#eac43c guifg=#b5382d

" Folds
" hi Folded ctermfg=248 ctermbg=0
hi FoldColumn ctermfg=red ctermbg=none guifg=red guibg=NONE

" Signs
hi SignColumn ctermfg=red ctermbg=none guifg=red guibg=NONE

" Marks
hi hlShowMarks ctermfg=lightgrey ctermbg=none guifg=#bbbbbb guibg=NONE

" Error, Todo, Syntastic symbols
hi Error ctermfg=red ctermbg=none guifg=red guibg=NONE
hi Todo ctermfg=yellow ctermbg=none guifg=orange guibg=NONE

" Invisibles
hi NonText    term=bold ctermfg=0 guifg=#666666
hi SpecialKey term=bold ctermfg=0 guifg=#666666
let g:indentLine_color_term=0
let g:indentLine_color_gui='#666666'

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
    let a:palette.normal.airline_file[1] = '#404040'
    let a:palette.normal.airline_file[3] = 236
  endif
endfunction

let g:airline_section_z = '%l:%c %p%%'

let g:airline#extensions#branch#enabled = 1

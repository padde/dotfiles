" Always show the statusline
set laststatus=2

" Use fancy symbols in powerline
let g:Powerline_symbols = 'fancy'

" Remove fileformat segment (too many there!)
call Pl#Theme#RemoveSegment('fileformat')

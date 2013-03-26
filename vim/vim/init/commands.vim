" Open up dotfiles dir
command Dotfiles :cd ~/.dotfiles | :NERDTree
command Dot :Dotfiles

" Filetype shortcuts
command Apex :set ft=apex
command Xml  :set ft=xml
command Ruby :set ft=ruby

" Write and quit
command Wsudo :w !sudo tee %
command WQ wq
command Wq wq
command W w
command Q q

" Clear search string
command ClearSearch :let @/ = ""
command CS :ClearSearch

" Remove trailing whitespace including non-breaking spaces
function! RemoveTrailingWhitespace()
  for lineno in range(a:firstline, a:lastline)
    let line = getline(lineno)
    let cleanLine = substitute(line, '\(\s\| \)\+$', '', 'e')
    call setline(lineno, cleanLine)
  endfor
endfunction
command -range RemoveTrailingWhitespace <line1>,<line2>call RemoveTrailingWhitespace()
command -range RT                       <line1>,<line2>call RemoveTrailingWhitespace()

" Diff with last saved version
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command DiffWithSaved call s:DiffWithSaved()
command DiffSaved call s:DiffWithSaved()
command DS call s:DiffWithSaved()

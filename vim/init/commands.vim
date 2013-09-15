" Open up dotfiles dir
command Dotfiles :cd ~/.dotfiles | :NERDTree
command Dot :Dotfiles

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
command -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
command -range=% RT                       <line1>,<line2>RemoveTrailingWhitespace
nnoremap <Leader>rt :RemoveTrailingWhitespace<CR>
vnoremap <Leader>rt :RemoveTrailingWhitespace<CR>

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

" gundo shortcuts in gui
if has('gui_running')
  nnoremap <D-u>      :GundoToggle<CR>
  inoremap <D-u> <Esc>:GundoToggle<CR>
  vnoremap <D-u> <Esc>:GundoToggle<CR>
endif

" Close all open buffers on entering a window if the only
" buffers that are left are Gundo buffers
function! s:CloseIfOnlyGundoLeft()
  let gundoOpen    = ( bufwinnr('__Gundo__')         != -1 )
  let gundoPreOpen = ( bufwinnr('__Gundo_Preview__') != -1 )

  " If only Gundo windows are left
  if winnr('$') == (gundoOpen + gundoPreOpen)
    :GundoHide
    quit
  endif
endfunction

au WinEnter * call s:CloseIfOnlyGundoLeft()

" Enable running commands in current dir
let g:NERDTreeChDirMode=2

" GUI shortcuts
if has('gui_running')
  nnoremap <D-d>      :NERDTreeToggle<CR><C-w>p
  inoremap <D-d> <Esc>:NERDTreeToggle<CR><C-w>pa
  vnoremap <D-d> <Esc>:NERDTreeToggle<CR><C-w>pgv
endif

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists('t:NERDTreeBufName')
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr('$') == 1
        q
      endif
    endif
  endif
endfunction

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

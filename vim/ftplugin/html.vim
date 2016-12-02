nnoremap <D-r> :silent !open %<CR>
inoremap <D-r> <ESC>:silent !open %<CR>a
vnoremap <D-r> <ESC>:silent !open %<CR>gv

" External dependencies:
" brew install tidy-html5
setlocal equalprg=tidy\ -q\ -i\ -w\ 0\ --show-errors\ 0\ --tidy-mark\ 0

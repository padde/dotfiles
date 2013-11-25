" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

map  <up>    gk
map  <down>  gj
imap <up>    <esc>gka
imap <down>  <esc>gja

" enable going to previous/next line with left/right arrow keys
" set whichwrap+=<,>,[,]

" add four lines below current line, positioning cursor on second of these
" lines
nmap <Leader>o o<CR><ESC>O<ESC>O<ESC>i

" clear search
nnoremap <Leader>cs :nohlsearch<CR>

" seeing is believing
nmap <buffer> <Leader>sr <Plug>(seeing-is-believing-run)
xmap <buffer> <Leader>sr <Plug>(seeing-is-believing-run)
nmap <buffer> <Leader>sm <Plug>(seeing-is-believing-mark)
xmap <buffer> <Leader>sm <Plug>(seeing-is-believing-mark)

" ack/ag
nmap <leader>a :Ack<space>

" ctrl-p
nmap <leader>t :CtrlP<CR>
nmap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>

" substitution
nmap <leader>s :%s///g<left><left>

" toggle wrap
function! ToggleWrap()
  if &list
    set nolist wrap lbr
  else
    set list nowrap nolbr
  endif
endfunction
nmap <leader>w :call ToggleWrap()<cr>

" quick comment toggle
nmap <leader><leader> \\\
vmap <leader><leader> \\

" jump to beginning/end of indentation level
com! StartOfIndent exe "norm vii\<esc>^"
com! EndOfIndent exe "norm viio\<esc>^"
nmap <leader>bi :StartOfIndent<cr>
nmap <leader>ei :EndOfIndent<cr>

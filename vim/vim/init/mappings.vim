" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" disable arrow keys
map  <up>    <nop>
map  <down>  <nop>
map  <left>  <nop>
map  <right> <nop>
imap <up>    <nop>
imap <down>  <nop>
imap <left>  <nop>
imap <right> <nop>

" enable going to previous/next line with left/right arrow keys
" set whichwrap+=<,>,[,]

" add four lines below current line, positioning cursor on second of these
" lines
nmap <Leader>o o<CR><ESC>O<ESC>O<ESC>i

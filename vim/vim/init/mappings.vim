" Highlight last pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" visually select matches
noremap <C-n> <ESC>//<CR>v//e<CR>
noremap <C-m> <ESC>NN//<CR>v//e<CR>

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

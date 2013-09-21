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

" add 'very magic' modifier to regexes
nnoremap / /\v
cnoremap s/ s/\v
cnoremap g/ g/\v
cnoremap g!/ g!/\v
cnoremap v/ v/\v

" clear search
nnoremap <Leader>cs :nohlsearch<CR>

" seeing is believing
nmap <buffer> <Leader>sr <Plug>(seeing-is-believing-run)
xmap <buffer> <Leader>sr <Plug>(seeing-is-believing-run)
nmap <buffer> <Leader>sm <Plug>(seeing-is-believing-mark)
xmap <buffer> <Leader>sm <Plug>(seeing-is-believing-mark)

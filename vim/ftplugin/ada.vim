autocmd BufWritePost *.ad{b,s} silent! !gnatpp -rf % 2&>1
set shiftwidth=3
set tabstop=3
set softtabstop=3

autocmd BufRead,BufNewFile *.cls     set ft=apex
autocmd BufRead,BufNewFile *.trigger set ft=apex

autocmd FileType apex set commentstring=\/\/\ %s
autocmd FileType apex set shiftwidth=4
autocmd FileType apex set softtabstop=4

autocmd BufRead,BufNewFile *.page set ft=xml
autocmd BufRead,BufNewFile *.page set shiftwidth=4
autocmd BufRead,BufNewFile *.page set softtabstop=4

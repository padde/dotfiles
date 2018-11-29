" replace arrow style hash keys with colon style
command! -range=% Hashify keeppatterns <line1>,<line2>s/:\(\w\+\)\s*=>\s*/\1: /g
xmap <leader>h :Hashify<cr>

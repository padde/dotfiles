" persist undo history
set undodir=~/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

" persist folds
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

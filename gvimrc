set guifont=Menlo\ Regular:h14

if has('gui_running')
  set guioptions=egmrt
endif

set vb

" Local config
if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif

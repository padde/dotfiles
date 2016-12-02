let xml_syntax_folding=1
setlocal foldmethod=syntax

" External dependencies:
" brew install tidy-html5
setlocal equalprg=tidy\ -q\ -i\ -w\ 0\ --show-errors\ 0\ --tidy-mark\ 0\ -xml

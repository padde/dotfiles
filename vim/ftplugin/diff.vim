function! CycleDiffPrefixes()
  let line = getline('.')
  let prefix = line[0]

  if prefix == '+'
    let prefix = '-'
  elseif prefix == '-'
    let prefix = '#'
  elseif prefix == '#'
    let prefix = ' '
  elseif prefix == ' '
    let prefix = '+'
  endif

  let repl = prefix . line[1:]
  call setline('.', repl)
endfunction

nnoremap <space> :call CycleDiffPrefixes()<cr>

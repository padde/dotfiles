if !exists('g:test#elixir#exercism#file_pattern')
  let g:test#elixir#exercism#file_pattern = '_test\.exs$'
endif

function! test#elixir#exercism#test_file(file) abort
  let fullpath = getcwd() . '/' . a:file
  return a:file =~# g:test#elixir#exercism#file_pattern && fullpath =~# 'exercism'
endfunction

function! test#elixir#exercism#build_position(type, position) abort
  let dir = fnamemodify(a:position['file'], ":h")
  return ['-r', dir.'/*.exs', a:position['file']]
endfunction

function! test#elixir#exercism#build_args(args) abort
  return a:args
endfunction

function! test#elixir#exercism#executable() abort
  return 'EXERCISM_TEST_EXAMPLES=1 elixir'
endfunction

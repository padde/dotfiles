set tabstop=4 softtabstop=4 shiftwidth=4

if !exists("g:ToggleTestLoaded")
  let g:ToggleTestLoaded = 1

  function! s:isTest(file)
    return a:file =~ 'Test.cls'
  endfunction

  function! s:TestFileName(file)
    return substitute(a:file, '.cls', 'Test.cls', '')
  endfunction

  function! s:ClassFileName(file)
    return substitute(a:file, 'Test.cls', '.cls', '')
  endfunction

  function! s:ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction

  function! g:ToggleTest()
    let currentFile = expand('%')
    let otherFile = ''

    if s:isTest(currentFile)
      let otherFile = s:ClassFileName(currentFile)
    else
      let otherFile = s:TestFileName(currentFile)
    endif

    if otherFile != currentFile
      exec 'edit '.otherFile
      call s:ResCur()
    else
      echo 'Could not find a matching class'
    endif
  endfunction

  nnoremap <leader>t :call g:ToggleTest()<CR>
endif

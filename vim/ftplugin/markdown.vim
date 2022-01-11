function MarkdownLevel(lnum)
  for synID in synstack(a:lnum, 1)
    let name = synIDattr(synID, "name")
    if     name == 'htmlH1' | return ">1"
    elseif name == 'htmlH2' | return ">2"
    elseif name == 'htmlH3' | return ">3"
    elseif name == 'htmlH4' | return ">4"
    elseif name == 'htmlH5' | return ">5"
    elseif name == 'htmlH6' | return ">6"
    endif
  endfor
  return "="
endfunction

setlocal foldexpr=MarkdownLevel(v:lnum)
setlocal foldmethod=expr
setlocal foldlevel=1

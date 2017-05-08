" Correct Indentation
function! CorrectIndentation()
  execute "silent normal! gg=G"
endfunction

" RENAME CURRENT FILE (thanks Gary Bernhardt) (thanks Ben Orenstein)
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

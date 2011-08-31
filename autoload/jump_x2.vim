function! jump_x2#to_first()  
  let [back, forward] = s:_jumplist()

  execute 'normal!' back . "\<C-o>"
endfunction

function! jump_x2#to_last()  
  let [back, forward] = s:_jumplist()

  execute 'normal' (s:skip(forward) . "\<Plug>(jump_x2-to-next-position)")
endfunction

function! jump_x2#to_next()  
  let [back, forward] = s:_jumplist()
  let current_bufnr = bufnr('')

  for _ in range(forward)
    execute 'normal' "\<Plug>(jump_x2-to-next-position)"

    if bufnr('') != current_bufnr
      break
    endif
  endfor

  if bufnr('') == current_bufnr
    for _ in range(forward)
      execute 'normal!' "\<C-o>"
    endfor
    echo 'Already jumped to last buffer'
  endif

  return
endfunction

function! jump_x2#to_previous()  
  let [back, forward] = s:_jumplist()
  let current_bufnr = bufnr('')

  for _ in range(back)
    execute 'normal!' "\<C-o>"

    if bufnr('') != current_bufnr
      break
    endif
  endfor

  if bufnr('') == current_bufnr
    for _ in range(back)
      execute 'normal' "\<Plug>(jump_x2-to-next-position)"
    endfor
    echo 'Already jumped to first buffer'
  endif

  return
endfunction

nnoremap <silent> <Plug>(jump_x2-to-next-position)  <C-i>

nnoremap <SID>0  0
nnoremap <SID>1  1
nnoremap <SID>2  2
nnoremap <SID>3  3
nnoremap <SID>4  4
nnoremap <SID>5  5
nnoremap <SID>6  6
nnoremap <SID>7  7
nnoremap <SID>8  8
nnoremap <SID>9  9

function! jump_x2#_sid()  
  nnoremap <SID>  <SID>
  return maparg('<SID>', 'n')
endfunction

function! s:_jumplist()  
  redir => jumplist
  silent! jumps
  redir END

  let ids = split(jumplist, '\n')
  call map(ids, 'matchstr(v:val, ''^\s*\zs\d\+\ze\s\+\d\+\s\+\d\+\s\+.*$'')')
  call filter(ids, 'v:val != ""')

  let back = 0
  let forward = 0

  if len(ids) > 0
    for i in range(1, len(ids) - 1)
      let diff = ids[i - 1] - ids[i]
      if 0 <= diff
        let back += 1
      endif
      if diff <= 0
        let forward += 1
      endif
    endfor
  endif

  if back == 0
    let forward += 1
  endif
  if forward == 0
    let back += 1
  endif

  return [back, forward]
endfunction

function! s:skip(jump)  
  if 1 <= a:jump
    let SID = substitute(jump_x2#_sid(), '<SNR>', "\<SNR>", '')
    return join(map(split(string(a:jump), '\zs\ze'), 'SID . v:val'), '')
  else
    return ''
  endif
endfunction

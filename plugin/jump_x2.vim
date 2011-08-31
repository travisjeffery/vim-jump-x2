if exists('g:loaded_jump_x2')
  finish
endif

nnoremap <silent> <Plug>(jump-x2-to-next) :<C-u>call jump_x2#to_next()<Return>
nnoremap <silent> <Plug>(jump-x2-to-last) :<C-u>call jump_x2#to_last()<Return>
nnoremap <silent> <Plug>(jump-x2-to-first) :<C-u>call jump_x2#to_first()<Return>
nnoremap <silent> <Plug>(jump-x2-to-previous) :<C-u>call jump_x2#to_previous()<Return>

let g:loaded_jump_x2 = 1

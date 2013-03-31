
command! TmpBookmarkNext call tmp_bookmarker#next(expand('%:p'))
command! TmpBookmarkAdd call tmp_bookmarker#push(expand('%:p'))
command! TmpBookmarkPop call tmp_bookmarker#pop()
command! TmpBookmarkShow echo string(tmp_bookmarker#stacked())
command! TmpBookmarkDelete call tmp_bookmarker#delete(expand('%:p'))

let g:tmp_bookmarker_scope_tab = 1
augroup tmp-bookmark
  autocmd!
  autocmd BufDelete,BufWipeout * call tmp_bookmarker#delete(expand('%:p'))
augroup END


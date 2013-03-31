
let s:save_cpo = &cpo
set cpo&vim

function! s:scoped_bookmarker()
  let tab_scope = get(g:, "tmp_bookmarker_scope_tab", 1)
  if tab_scope
    if !exists("t:tmp_bookmarked")
      let t:tmp_bookmarked = []
    endif
    return t:tmp_bookmarked
  else
    if !exists("g:tmp_bookmarked")
      let g:tmp_bookmarked = []
    endif
    return g:tmp_bookmarked
  end
endfunction

function! tmp_bookmarker#next(current)
  let l:bookmarked = s:scoped_bookmarker()
  if !empty(l:bookmarked)
    let l:index = index(l:bookmarked, a:current)
    if len(l:bookmarked) == (l:index + 1)
      let l:index = -1
    endif
    let l:file = l:bookmarked[l:index + 1]
    execute "edit " . l:file
  endif
endfunction

function! tmp_bookmarker#pop()
  let l:bookmarked = s:scoped_bookmarker()
  if !empty(l:bookmarked)
    let l:last = remove(t:tmp_bookmarked, -1)
    execute "edit " . l:last
  endif
endfunction

function! tmp_bookmarker#push(file)
  let l:bookmarked = s:scoped_bookmarker()
  if !empty(a:file)
    call add(l:bookmarked, a:file)
  endif
endfunction

function! tmp_bookmarker#delete(file)
  let l:bookmarked = s:scoped_bookmarker()
  if !empty(l:bookmarked)
    let l:index = index(l:bookmarked, a:file)
    if l:index
      call remove(l:bookmarked, l:index)
    endif
  endif
endfunction

function! tmp_bookmarker#stacked()
  return s:scoped_bookmarker()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


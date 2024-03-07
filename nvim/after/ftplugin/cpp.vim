setlocal ts=4
setlocal sw=4
setlocal noexpandtab
nnoremap <buffer> <C-j> :Unite gtags/context<CR>
let g:context_highlight_enable_source_name = ["current_word"]


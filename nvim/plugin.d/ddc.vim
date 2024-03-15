
call ddc#custom#patch_global({
 \ 'ui': "native",
 \ 'sources': [
 \   'around',
 \   'vim-lsp',
 \   'skkeleton',
 \   'file',
 \ ],
 \ 'sourceOptions': {
 \   '_': {
 \     'matchers': ['matcher_head'],
 \     'sorters': ['sorter_rank'],
 \     'converters': ['converter_remove_overlap'],
 \   },
 \   'around': {'mark': 'A'},
 \   'vim-lsp': {
 \     'mark': 'L',
 \     'matchers': ['matcher_head'],
 \     'forceCompletionPattern': '\.|:|->|"\w+/*'
 \   },
 \     'skkeleton': {
 \       'mark': 'skk',
 \       'matchers': ['skkeleton'],
 \       'sorters': [],
 \       'minAutoCompleteLength': 2,
 \     },
 \   'file': {
 \     'mark': 'F',
 \     'isVolatile': v:true,
 \     'forceCompletionPattern': '\S/\S*'
 \ }}
 \ })
call ddc#enable()
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

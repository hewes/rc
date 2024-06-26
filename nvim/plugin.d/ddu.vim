
if exists("g:ddu#_initialized") && !g:ddu#_initialized
  finish
endif

let g:ddu_source_lsp_clientName = "nvim-lsp"
let s:file_source = {
    \      'name': 'file',
    \      'options':
    \          {
    \             'converters': ['converter_hl_dir', 'converter_devicon']
    \          },
    \    }

let s:file_sources = [
    \  s:file_source,
    \ ]

function s:file_open_parent(args)
  let items = a:args->get('items')
  let action = items[0]->get('action')
  let curdir = fnamemodify(action->get('path'), ':h')
  let upper = fnamemodify(curdir . "/../", ':p')
  call ddu#start({
        \ 'sources': [s:file_source],
        \ 'sourceOptions': {'file': { 'path': upper },},
        \ 'uiParams': {
        \   'ff': {
        \     'floatingTitle' : upper,
        \    }
        \  }
        \ })
  return 0
endfunction

call ddu#custom#action('kind', 'file', 'open_parent', function('s:file_open_parent'))

call ddu#custom#patch_global({
      \   'ui': 'ff',
      \   'uiParams': {
      \     'ff': {
      \       'startFilter': v:true,
      \       'prompt': '> ',
      \       'split': has('nvim') ? 'floating' : 'horizontal',
      \       'floatingBorder': "rounded",
      \       'filterFloatingPosition': "top",
      \       'floatingTitle' : "Title",
      \       'highlights' : {
      \         'floatingCursorLine' : 'CursorLine',
      \         'filterText' : 'Statement',
      \         'floating' : 'Normal',
      \         'floatingBorder' : 'Special',
      \       },
      \       'previewWindowOptions' : [
      \         [ "&signcolumn", "no" ],
      \         [ "&foldcolumn", 0 ],
      \         [ "&foldenable", 0 ],
      \         [ "&number", 1 ],
      \         [ "&wrap", 0 ],
      \         [ "&scrolloff", 0 ],
      \       ],
      \       'startAutoAction' : v:false,
      \       'previewFloaing': v:true,
      \       'previewFloaingBorder': 'single',
      \       'previewFloating' : v:true,
      \       'previewFloatingBorder' : 'single',
      \       'previewSplit' : 'vertical',
      \       'previewFloatingTitle' : "Preview",
      \     },
      \   },
      \   'kindOptions': {
      \     'action': {
      \       'defaultAction': 'do',
      \     },
      \     'file': {
      \       'defaultAction': 'open',
      \     },
      \     'lsp': {
      \       'defaultAction': "open",
      \     },
      \     'ui_select': {
      \       'defaultAction': "select",
      \     },
      \   },
      \   'sourceOptions': {
      \     '_': {
      \       'matchers': ['matcher_substring'],
      \     },
      \     'file': {
      \       'sorters': ['sorter_alpha'],
      \     },
      \   },
      \ 'sources': [
      \   {
      \     'name': 'file_rec',
      \     'params': {
      \       'ignoredDirectories': ['.git', 'node_modules', 'venv'],
      \     },
      \   },
      \   {
      \     'name': 'rg',
      \     'params': {
      \       'args': ['--column', '--no-heading', '--color', 'never'],
      \     },
      \   },
      \ ],
      \})

call ddu#custom#patch_local("buffer", {
      \   'kindOptions': {
      \     'file': {
      \       'defaultAction': "open",
      \     },
      \   },
      \ })

nnoremap ff f
nmap f [ddu]
xmap f [ddu]
nnoremap [ddu] <Nop>
xnoremap [ddu] <Nop>

function! s:get(key) abort
  return get(s:, a:key)
endfunction


function s:resize()
  let height = floor(&lines * 0.8)
  let row = floor(&lines * 0.1)
  let width = floor(&columns * 0.8)
  let col = floor(&columns * 0.1)
  let previewWidth = floor(width / 2)

  call ddu#custom#patch_global({
      \  'uiParams': {
      \    'ff': {
      \       'winWidth': width,
      \       'winHeight': height,
      \       'winCol': col,
      \       'winRow': row,
      \       'previewHeight' : height,
      \       'previewRow' : row,
      \       'previewWidth' : previewWidth,
      \       'previewCol' : col + (width - previewWidth),
      \    }
      \  }
      \ })
endfunction
call s:resize()


nnoremap <silent> [ddu]b <Cmd>call ddu#start({
    \ 'name': 'current buffer dir',
    \ 'sources': <sid>get('file_sources'),
    \ 'sourceOptions': {'_': #{ path: expand("%:p:h") },},
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : expand("%:p:h"),
    \    }
    \  }
    \ })<CR>
nnoremap <silent> [ddu]c <Cmd>call ddu#start({
    \ 'name': 'current',
    \ 'sources': <sid>get('file_sources'),
    \ 'sourceOptions': {'_': #{ path: expand("./") },},
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : expand("./"),
    \    }
    \  }
    \ })<CR>
nnoremap <silent> [ddu]h <Cmd>call ddu#start({
    \ 'name': 'home',
    \ 'sources': <sid>get('file_sources'),
    \ 'sourceOptions': {'_': #{ path: expand("~") },},
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : expand("~")
    \    }
    \  }
    \ })<CR>
" most recent used
nnoremap <silent> [ddu]m <Cmd>call ddu#start({
    \ 'name': 'file_old',
    \ 'sources': [{'name': 'file_old'}],
    \ 'kindOptions': {
    \     'file': {
    \       'defaultAction': "open",
    \     },
    \  },
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : "file_old",
    \    }
    \  }
    \ })<CR>
nnoremap <silent> [ddu]l <Cmd>call ddu#start({
    \ 'name': 'line',
    \ 'sources': [{'name': 'line'}],
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : "Line",
    \    }
    \  }
    \ })<CR>
nnoremap <silent> [ddu]j <Cmd>call ddu#start({
    \ 'name': 'buffer',
    \ 'sources': [{'name': 'buffer'}],
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : "Buffers",
    \    }
    \  }
    \ })<CR>
nnoremap <silent> [ddu]o <Cmd>call ddu#start({
    \ 'name': 'outline',
    \ 'sources': [
    \   {
    \       'name': 'lsp_documentSymbol',
    \       'options':
    \          {
    \             'converters': ['converter_lsp_symbol'],
    \             'sorters': [],
    \          }
    \   }
    \  ],
    \ 'uiParams': {
    \   'ff': {
    \     'floatingTitle' : "LSP-Symbols",
    \     'autoAction': {'name': 'preview'},
    \     'startAutoAction' : v:true,
    \    }
    \  }
    \ })<CR>
nnoremap <silent> gr <Cmd>call ddu#start({
    \ 'name': 'lsp-references',
    \ 'sources': [
    \   {
    \       'name': 'lsp_references',
    \       'options':
    \          {'converters': ['converter_lsp_symbol']}
    \   }
    \  ],
    \ 'uiParams': {
    \   'ff': {
    \     'startFilter': v:false,
    \     'immediateAction': 'open',
    \     'autoAction': {'name': 'preview'},
    \     'startAutoAction' : v:true,
    \     'floatingTitle' : "LSP-References",
    \    }
    \  }
    \ })<CR>
nnoremap <silent> gd <Cmd>call ddu#start({
    \ 'name': 'lsp-definition',
    \ 'sources': [
    \   {
    \       'name': 'lsp_definition',
    \   }
    \  ],
    \ 'uiParams': {
    \   'ff': {
    \     'startFilter': v:false,
    \     'immediateAction': 'open',
    \     'autoAction': {'name': 'preview'},
    \     'startAutoAction' : v:true,
    \     'floatingTitle' : "LSP-Definitions",
    \    }
    \  }
    \ })<CR>

nnoremap <silent> gc <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'lsp_callHierarchy',
      \   params: #{
      \     method: 'callHierarchy/outgoingCalls',
      \   }
      \ }],
      \ uiParams: #{
      \   ff: #{
      \     displayTree: v:true,
      \     startFilter: v:false,
      \     autoAction: {'name': 'preview'},
      \     startAutoAction : v:true,
      \     floatingTitle : "LSP-CallHierarchy",
      \   },
      \ }
      \})<CR>

nnoremap <silent> [ddu]g <Cmd>call ddu#start(#{
      \ sources: [{
      \   'name': 'rg',
      \   'params': {'input': input('Pattern: ')},
      \ }],
      \ uiParams: #{
      \   ff: #{
      \     displayTree: v:true,
      \     startFilter: v:false,
      \     autoAction: {'name': 'preview'},
      \     startAutoAction : v:true,
      \     floatingTitle : "ripgrep",
      \   },
      \ }
      \})<CR>

"nnoremap <silent> [ddu]p :Unite bookmark -default-action=cd -no-start-insert<CR>
"nnoremap <expr> [ddu]g ':Unite grep:'. expand("%:h") . ':-r'
"nnoremap <silent> [ddu]o :Unite -buffer-name=outline outline<CR>
"nnoremap <silent> [ddu]q :Unite quickfix -no-start-insert<CR>

function! s:ddu_ff_settings() abort
  setlocal cursorline
  nnoremap <buffer><silent><expr> <CR>
        \ ddu#ui#get_item()->get('kind', '') ==# 'file' && ddu#ui#get_item()->get('action')->get('isDirectory') ?
         \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
         \ "<ESC><Cmd>call ddu#ui#do_action('itemAction')<CR>"
  nnoremap <buffer><silent> e
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'file_rec'})<CR>
  nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> d
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'delete'})<CR>
  nnoremap <buffer><silent> q <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> e <Cmd>call ddu#ui#do_action('expandItem',#{mode: "toggle"})<CR>
  nnoremap <buffer><silent> <C-j> <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> p <Cmd>call ddu#ui#do_action('toggleAutoAction')<CR>
  nnoremap <buffer><silent> j <Cmd>call <SID>go_down()<CR>
  nnoremap <buffer><silent> k <Cmd>call <SID>go_up()<CR>
  nnoremap <buffer><silent> <TAB>
        \ <Esc><Cmd>call ddu#ui#do_action('chooseAction')<CR>
  nmap <C-n> j
  nmap <C-p> k
  nnoremap <buffer><silent> u
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open_parent'})<CR>
endfunction

function! s:ddu_ff_filter_settings() abort
  " if virtualedit is on, cursor stays same column after do action..
  " it is caused by cursor('$'->line(), 0) at ddu/ui/ff/filter.vim
  setlocal virtualedit=none
  filetype indent off
  inoremap <buffer><silent><expr> <CR>
        \ ddu#ui#get_item()->get('kind', '') ==# 'file' && ddu#ui#get_item()->get('action')->get('isDirectory') ?
        \ "<ESC><Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow'})<CR>" :
        \ "<ESC><Cmd>call ddu#ui#do_action('itemAction')<CR>"
  inoremap <buffer><silent> <TAB>
        \ <Esc><Cmd>call ddu#ui#do_action('chooseAction')<CR>
  inoremap <buffer><silent> <C-j>
        \ <Esc><Cmd>call ddu#ui#do_action('quit')<CR>
  inoremap <buffer><silent> <C-u>
        \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open_parent'})<CR>

  nnoremap <buffer><silent> <C-j> <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> <CR> <Cmd>close<CR>
  nnoremap <buffer><silent> q <Cmd>close<CR>
  inoremap <nowait><buffer><silent> <C-q> <ESC>:close<CR>
  inoremap <nowait><buffer><silent> <C-n> <Cmd>call <SID>go_down()<CR>
  inoremap <nowait><buffer><silent> <C-p> <Cmd>call <SID>go_up()<CR>
  inoremap <nowait><buffer><silent> <C-f> <Cmd>call <SID>exe_parent('normal! <C-f>')<CR>
  inoremap <nowait><buffer><silent> <C-b> <Cmd>call <SID>exe_parent('normal! <C-b>')<CR>
endfunction

function! s:go_up() abort
  if &filetype == "ddu-ff"
    let l:winid = win_getid()
  else
    let l:winid = g:ddu#ui#ff#_filter_parent_winid
  endif
  let l:pos = getcurpos(l:winid)
  if l:pos[1] == 1
    call s:exe_parent('normal! G')
  else
    call s:exe_parent('normal! k')
  endif
endfunction

function! s:go_down() abort
  if &filetype == "ddu-ff"
    let l:winid = win_getid()
  else
    let l:winid = g:ddu#ui#ff#_filter_parent_winid
  endif
  let l:pos = getcurpos(l:winid)
  if l:pos[1] == line('$', l:winid)
    call s:exe_parent('normal! gg')
  else
    call s:exe_parent('normal! j')
  endif
endfunction

function! s:exe_parent(expr) abort
  if &filetype == "ddu-ff"
    " call from ddu-ff
    call execute(a:expr)
  else
    " call from ddu-ff-filter
    if !exists('g:ddu#ui#ff#_filter_parent_winid')
      return
    endif
    call win_execute(g:ddu#ui#ff#_filter_parent_winid, a:expr)
  endif
endfunction

augroup my-ddu
  autocmd!
  autocmd FileType ddu-ff call s:ddu_ff_settings()
  autocmd FileType ddu-ff-filter call s:ddu_ff_filter_settings()
  autocmd VimResized * call <SID>resize()
augroup END


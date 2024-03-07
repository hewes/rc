
function! s:init() abort
  call jetpack#begin()
  " bootstrap
  call jetpack#add('tani/vim-jetpack', { 'opt': 1 })

  call jetpack#add('tpope/vim-surround')
  call jetpack#add('tpope/vim-repeat.git')
  call jetpack#add('vim-airline/vim-airline')
  call jetpack#add('vim-airline/vim-airline-themes')

  call jetpack#add('scrooloose/nerdcommenter')
  call jetpack#add('h1mesuke/vim-alignta')
  call jetpack#add('vim-denops/denops.vim')
  call jetpack#add('vim-skk/skkeleton', {"depends": "denops.vim"})
  call jetpack#add('kana/vim-smartchr')
 
  "LSP
  call jetpack#add('neovim/nvim-lspconfig')
  call jetpack#add('williamboman/mason.nvim')
  call jetpack#add('williamboman/mason-lspconfig.nvim')
  call jetpack#add('hedyhli/outline.nvim')

  " ddu
  call jetpack#add('Bakudankun/ddu-filter-matchfuzzy')
  call jetpack#add('Milly/ddu-filter-kensaku')
  call jetpack#add('Milly/ddu-filter-merge')
  call jetpack#add('Shougo/dda.vim', {"depends": "denops.vim"})
  call jetpack#add('Shougo/ddu-column-filename')
  call jetpack#add('Shougo/ddu-commands.vim')
  call jetpack#add('Shougo/ddu-filter-matcher_substring')
  call jetpack#add('Shougo/ddu-filter-sorter_alpha')
  call jetpack#add('Shougo/ddu-filter-sorter_reversed')
  call jetpack#add('Shougo/ddu-kind-file')
  call jetpack#add('Shougo/ddu-kind-word')
  call jetpack#add('Shougo/ddu-source-action')
  call jetpack#add('Shougo/ddu-source-file')
  call jetpack#add('Shougo/ddu-source-file_rec')
  call jetpack#add('Shougo/ddu-source-file_old')
  call jetpack#add('Shougo/ddu-source-line')
  call jetpack#add('uga-rosa/ddu-source-lsp')
  call jetpack#add('uga-rosa/ddu-filter-converter_devicon')
  call jetpack#add('kyoh86/ddu-filter-converter_hl_dir')
  call jetpack#add('shun/ddu-source-buffer')
  call jetpack#add('Shougo/ddu-source-register')
  call jetpack#add('Shougo/ddu-ui-ff')
  call jetpack#add('Shougo/ddu.vim', {"depends": "denops.vim"})
  call jetpack#add('kuuote/ddu-source-mr')
  call jetpack#add('matsui54/ddu-source-command_history')
  call jetpack#add('matsui54/ddu-source-help')
  call jetpack#add('matsui54/ddu-vim-ui-select')
  call jetpack#add('mikanIchinose/ddu-source-markdown')

  call jetpack#end()
endfunction

function! s:load_vim_configurations() abort
  for path in glob('$VIMHOME/plugin.d/*.vim', 1, 1, 1)
    execute printf('source %s', fnameescape(path))
  endfor
endfunction

function! s:load_lua_configurations() abort
  for path in glob('$VIMHOME/plugin.d/*.lua', 1, 1, 1)
    execute printf('luafile %s', fnameescape(path))
  endfor
endfunction

call s:init()
call s:load_vim_configurations()
call s:load_lua_configurations()

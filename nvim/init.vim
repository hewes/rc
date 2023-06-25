" ======== Initialize Section {{{
if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
augroup END
"}}}
" ======== Jetpack setting {{{
call jetpack#begin()
  " bootstrap
  call jetpack#add('tani/vim-jetpack', { 'opt': 1 })
  call jetpack#add('kylechui/nvim-surround')
  call jetpack#add('Shougo/ddu.vim')
  call jetpack#add('Shougo/ddu-ui-ff')
  call jetpack#add('Shougo/ddu-kind-file')
  call jetpack#add('Shougo/ddu-filter-matcher_substring')
  call jetpack#add('Shougo/ddu-source-file')
  call jetpack#add('Shougo/ddu-source-file_old')
  call jetpack#add('Shougo/ddu-source-line')
  call jetpack#add('Shougo/neomru.vim')
  call jetpack#add('Shougo/tabpagebuffer.vim')

  call jetpack#add('netvim/nvim-lspconfig')
  call jetpack#add('williamboman/mason.nvim')
  call jetpack#add('williamboman/mason-lspconfig.nvim')

  call jetpack#add('vim-airline/vim-airline')
  call jetpack#add('vim-airline/vim-airline-themes')

  call jetpack#add('lewis6991/gitsigns.nvim')
  call jetpack#add('scrooloose/nerdcommenter')
  call jetpack#add('h1mesuke/vim-alignta')
  call jetpack#add('vim-denops/denops.vim')
  call jetpack#add('vim-skk/skkeleton')
  call jetpack#add('kana/vim-smartchr')
call jetpack#end()

"}}}
" ======== Source Macro {{{
if filereadable($VIMRUNTIME . "/macros/matchit.vim")
  source $VIMRUNTIME/macros/matchit.vim
endif
" }}}
" ======== Util Function {{{
function! s:mkdir(file, ...)
  let f = a:0 ? fnamemodify(a:file, a:1) : a:file
  if !isdirectory(f)
    call mkdir(f, 'p')
  endif
endfunction

function! s:sysid_match(sys_ids)
  if index(a:sys_ids, s:syntax_id()) >= 0
    return 1
  else
    return 0
  endif
endfunction

function! s:syntax_id()
  return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction
command! SyntaxId echo s:syntax_id()

function! s:sum(array)
  let sum = 0
  for i in a:array
    let sum += i
  endfor
  return sum
endfunction

function! s:system(cmd) " execute external command async if possible
  if exists('g:loaded_vimproc')
    call vimproc#system(a:cmd)
  else
    call system(a:cmd)
  endif
endfunction

" for debugging {{{
let g:my_debugger = {'logs' : []}
function! g:my_debugger.log(str) dict
  call add(self.logs, a:str)
endfunction

function! g:my_debugger.result_of(cmd) dict
  call self.log('result of '. a:cmd)
  redir => result
  silent execute a:cmd
  redir END
  call self.log(result)
endfunction

function! g:my_debugger.clear() dict
  let self.logs = []
endfunction

function! g:my_debugger.output() dict
  if empty(self.logs) | return | endif
  try
    redir >> ~/.vim/debugging.log
    for msg in self.logs
      silent echo msg
    endfor
  finally
    redir END
    call self.clear()
  endtry
endfunction

command! -nargs=1 MyDebug call g:my_debugger.log(<q-args>)
command! OutputMyDebug call g:my_debugger.output()
command! ClearMyDebug call g:my_debugger.clear()
"}}}
"}}}
" ======== Basic Setting {{{
let s:has_win = has('win32') || has('win64')
filetype plugin indent on
syntax enable

" Exchange path separator.
if s:has_win
  set shellslash
  set shell=bash
else
  set shell=bash
endif

" split window direction
set splitbelow splitright

set hidden

" default indent setting
set autoindent
set cindent
" tab setting
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set smartindent
set updatetime=1000

set browsedir=buffer
set backspace=indent,eol,start
set clipboard=unnamed

" scroll
"set scroll=5
set scrolloff=0

"search settings
set ignorecase smartcase wrapscan incsearch hlsearch grepprg=internal
" use ack for grep
" set grepprg=ack\ -a

"Japanese input etc settings
set noimdisable noimcmdline

" ddc does not work if lmap is ON
set iminsert=0 imsearch=1

" beyond line
set whichwrap=b,s,h,l,<,>,[,]
" No auto return
set textwidth=0
" Completion option
set nowildmenu
set wildmode=list:full
" Virtual edit always
set virtualedit=all
set foldenable
set nrformats& nrformats-=octal

" Backup.
set backup
set backupdir=~/.backup
" Paths of swap file and backup file.
if $TMP !=# ''
  execute 'set backupdir+=' . escape(expand($TMP), ' \')
elseif has('unix')
  set backupdir+=/tmp
endif
let &directory = &backupdir
if has('persistent_undo')
  set undodir=~/.backup
  augroup vimrc-undofile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif
set backupcopy=yes

call s:mkdir(expand('~/.backup'))

" Round tab width
set shiftround
" tags
if has('path_extra')
  "set tags+=.;
  "set tags+=tags;
endif
set notagbsearch
" Show full taginfo
set showfulltag

" No Beep
set visualbell
set vb t_vb=
" Spell check language
set spelllang=en_us
" Completion setting.
set completeopt=menuone,preview
"set completeopt=menuone
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=20
" use help for K
set keywordprg=:help

set foldmethod=marker

set modeline

set display=lastline
if exists('&ambiwidth') && !exists('g:vscode')
  set ambiwidth=double
endif

" ------ The encoding setting {{{
if s:has_win
  " if windows use cp932
  if &encoding !=? 'cp932'
    set encoding=cp932
    let &termencoding = &encoding
  endif
else
  " else use utf-8.
  if &encoding !=? 'utf-8'
    set encoding=utf-8
    let &termencoding = &encoding
  endif
endif

if has('guess_encode')
  set fileencodings=ucs-bom,iso-2022-jp,guess,euc-jp,cp932
else
  set fileencodings=ucs-bom,iso-2022-jp,euc-jp,cp932
endif

augroup vimrc-fileencoding
  autocmd!
  autocmd BufReadPost * if &modifiable && !search('[^\x00-\x7F]', 'cnw')
        \                   |   setlocal fileencoding=
        \                   | endif
augroup END

" scriptencoding setting must be after encoding setting
scriptencoding  utf-8

"}}}

" ------- Default fileformat. {{{
if s:has_win
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif
" Automatic recognition of a new line cord.
" A fullwidth character is displayed in vim properly.
set ambiwidth=double
" }}}

" }}}
" ======== Key mappings {{{
" Map Leader {{{
let mapleader= ','
let g:mapleader = ','
let g:maplocalleader = 'm'
"}}}
" cmdwin mapping {{{
"nmap : <sid>(command-line-enter)
"xmap : <sid>(command-line-enter)
"nnoremap <sid>(command-line-enter) q:
"xnoremap <sid>(command-line-enter) q:
"nnoremap <sid>(command-line-norange) q:<C-u>
"}}}
" ---- insert mode {{{
inoremap <C-e> <END>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <ESC> <ESC>
inoremap <C-l> <C-o>w
" }}}
" ---- normal mode {{{
nnoremap <silent> <Leader><Leader> :bnext<CR>

nnoremap <Space> <Nop>
nnoremap <SPACE><SPACE> <C-^>
nnoremap ,t :tabnew<SPACE>
nnoremap Y y$
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap <expr> sw ':%s/\<' . expand('<cword>') .'\>/'
nnoremap sp "_ciw<C-r>0<ESC>

nnoremap <C-h> gT
nnoremap <C-l> gt

" tag shortcut
nnoremap t <Nop>
nnoremap tt <C-]>
nnoremap tj <C-u>:tag<CR>
nnoremap tk <C-u>:pop<CR>
nnoremap tl <C-u>:tags<CR>

" q: Quickfix "{{{

" use Q for q
nnoremap Q q
" The prefix key.
nnoremap [Quickfix] <Nop>
nmap q [Quickfix]
nmap [make] :<C-u>make<SPACE>

" For quickfix list "{{{
nnoremap <silent> [Quickfix]n :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]p :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]r :<C-u>crewind<CR>
nnoremap <silent> [Quickfix]N :<C-u>cfirst<CR>
nnoremap <silent> [Quickfix]P :<C-u>clast<CR>
nnoremap <silent> [Quickfix]fn :<C-u>cnfile<CR>
nnoremap <silent> [Quickfix]fp :<C-u>cpfile<CR>
nnoremap <silent> [Quickfix]l :<C-u>clist<CR>
nnoremap <silent> [Quickfix]q :<C-u>cc<CR>
nnoremap <silent> [Quickfix]en :<C-u>cnewer<CR>
nnoremap <silent> [Quickfix]ep :<C-u>colder<CR>
nnoremap <silent> [Quickfix]o :<C-u>copen<CR>
nnoremap <silent> [Quickfix]c :<C-u>cclose<CR>
nmap [Quickfix]m [make]
nnoremap [Quickfix]M q:make<Space>
nnoremap [Quickfix]g q:grep<Space>
" Toggle quickfix window.
nnoremap <silent> [Quickfix]<Space> :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction
"}}}
" For location list (mnemonic: Quickfix list for the current Window) "{{{
nnoremap <silent> [Quickfix]wn :<C-u>lnext<CR>
nnoremap <silent> [Quickfix]wp :<C-u>lprevious<CR>
nnoremap <silent> [Quickfix]wr :<C-u>lrewind<CR>
nnoremap <silent> [Quickfix]wP :<C-u>lfirst<CR>
nnoremap <silent> [Quickfix]wN :<C-u>llast<CR>
nnoremap <silent> [Quickfix]wfn :<C-u>lnfile<CR>
nnoremap <silent> [Quickfix]wfp :<C-u>lpfile<CR>
nnoremap <silent> [Quickfix]wl :<C-u>llist<CR>
nnoremap <silent> [Quickfix]wq :<C-u>ll<CR>
nnoremap <silent> [Quickfix]wo :<C-u>lopen<CR>
nnoremap <silent> [Quickfix]wc :<C-u>lclose<CR>
nnoremap <silent> [Quickfix]wep :<C-u>lolder<CR>
nnoremap <silent> [Quickfix]wen :<C-u>lnewer<CR>
nnoremap <silent> [Quickfix]wm :<C-u>lmake<CR>
nnoremap [Quickfix]wM q:lmake<Space>
nnoremap [Quickfix]w<Space> q:lmake<Space>
nnoremap [Quickfix]wg q:lgrep<Space>
"}}}
"}}}
" }}}
" ---- command mode {{{
" bash like key-bind at cmdline
cnoremap <C-h> <BS>
cnoremap <C-l> <ESC>
cnoremap <C-b> <Left>
cnoremap <C-e> <END>
cnoremap <C-a> <HOME>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>/
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>
" }}}
" ---- visual mode {{{
vnoremap $ $h
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap " "zdi"<C-R>z"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
" }}}
" }}}
" ======== Appearence Setting {{{
set title
set noruler

" always show tab
set showtabline=2
syntax on

" set cursolline only focused window
"augroup cch
"autocmd! cch
"autocmd WinLeave * set nocursorline
"autocmd WinEnter,BufRead * set cursorline
"augroup END

" cursor hilight setting
set nocursorline
set nocursorcolumn

set number
"set relativenumber

" list chars
set list
set listchars=eol:$,tab:>\ ,extends:<

set showcmd
set showmatch
set laststatus=2

"  window of quick fix preview
"set previewheight=32
" ----- color {{{
set t_Co=256
set background=dark

function! s:set_highlight() " color setting {{{
  highlight CurrentWord term=NONE ctermbg=52  ctermfg=NONE guibg=darkred
  highlight Indent      term=NONE ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
endfunction
" }}}
autocmd MyAutoCmd ColorScheme * call s:set_highlight()

try
  colorscheme capybara
catch /E185/
  colorscheme torte
endtry

" change cursor shape
if &term == "xterm-256color"
  "let &t_SI .= "\eP\e[5 q\e\\"
  "let &t_EI .= "\eP\e[1 q\e\\"
elseif &term == "xterm"
  "let &t_SI .= "\e[5 q"
  "let &t_EI .= "\e[1 q"
endif
" }}}
" ----- Tab label setting {{{
function! s:buf_name_on_tab(tab_num)
  let buflist  =  tabpagebuflist(a:tab_num)
  let winnr    =  tabpagewinnr(a:tab_num)
  return bufname(buflist[winnr - 1])
endfunction

if v:version < 703
  function! s:my_tab_label(tab_number)
    return s:buf_name_on_tab(a:tab_number)
  endfunction
else
  function! s:my_tab_label(tab_number)
    let l:project = gettabvar(a:tab_number, "project")
    if empty(l:project) || l:project == '[home]'
      let bufname   = s:buf_name_on_tab(a:tab_number)
      let path_tcwd = empty(bufname) ? "" : substitute(fnamemodify(bufname, ":p"), gettabvar(a:tab_number, "cwd") . "/", "", "g")
      return empty(l:project) ? path_tcwd : l:project . ' ' .  path_tcwd
    else
      return l:project
    endif
  endfunction
end

function! s:suitable_tab_indice(length_a, cur_tab)
  let l:win_width = winwidth(0)
  if a:length_a[a:cur_tab] > l:win_width
    return [a:cur_tab, a:cur_tab]
  endif
  let l:start_index = a:cur_tab
  if (a:cur_tab > 0) && (a:length_a[a:cur_tab-1] + a:length_a[a:cur_tab] < l:win_width)
    let l:start_index -= 1
  endif
  let l:length = a:length_a[l:start_index]
  let l:end_index = l:start_index
  let l:element_num = len(a:length_a) - 1
  while 1
    let l:tmp = l:end_index + 1
    if (l:tmp > l:element_num) || (l:length + a:length_a[l:tmp] > l:win_width)
      break
    endif
    let l:end_index += 1
    let l:length += a:length_a[l:end_index]
  endwhile
  while 1
    let l:tmp = l:start_index - 1
    if (l:tmp < 0 ) || (l:length + a:length_a[l:tmp] > l:win_width)
      break
    endif
    let l:start_index -= 1
    let l:length += a:length_a[l:start_index]
  endwhile
  return [l:start_index, l:end_index]
endfunction

function! MyTabLine()
  let label_a = []
  let length_a = []
  for i in range(1, tabpagenr('$'))
    let label = ' '. i . ' ' . s:my_tab_label(i) . ' '
    call add(label_a, (i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') . '%' .  i . 'T' . label)
    call add(length_a, len(label))
  endfor
  if s:sum(length_a) > winwidth(0)
    let indice = s:suitable_tab_indice(length_a, tabpagenr() - 1)
    " number of showing tabs
    let l:show = join(label_a[indice[0]:indice[1]])
  else
    let l:show = join(label_a, '')
  endif
  return l:show . '%#TabLineFill#%T'
endfunction
set tabline=%!MyTabLine()
" }}}
" ----- Input Japanese:"{{{
if has('multi_byte_ime')
  " Settings of default ime condition.
  set iminsert=0 imsearch=0
  " Don't save ime condition.
  autocmd MyAutoCmd InsertLeave * set iminsert=0 imsearch=0
  nnoremap / :<C-u>set imsearch=0<CR>/
  xnoremap / :<C-u>set imsearch=0<CR>/
  nnoremap ? :<C-u>set imsearch=0<CR>?
  xnoremap ? :<C-u>set imsearch=0<CR>?
  highlight Cursor ctermfg=NONE ctermbg=Green
  highlight CursorIM ctermfg=NONE ctermbg=Yellow
endif

"}}}

" ----- airline {{{
" theme is one of autoload/airline/themes
let g:airline_theme = 'wombat'
if has('multi_byte')
  " TODO should only enable on environment where the font is patched
  let g:airline_powerline_fonts = 0
endif
" fileformat[fileencoding]
let g:airline_section_y = "%{strlen(&ff)?&ff:''}" . "[%{strlen(&fenc)?&fenc:&enc}]"
let g:airline_section_z = "L:%l/%L C:%4c"
" }}}
" }}}
"
function! s:my_ddu_init()
  " https://github.com/Shougo/ddu-ui-ff
  call ddu#custom#patch_global({
        \ 'ui': 'ff',
        \ 'uiParams': {
        \     'ff': {
        \       'startFilter': v:true,
        \       'prompt': '> ',
        \       'split': 'floating',
        \       'floatingBorder': "rounded",
        \       'autoResize': v:true,
        \       'winHeight': 40,
        \       'filterFloatingPosition': "top",
        \       'previewFloaing': v:true,
        \       'previewFloaingBorder': 'single',
        \       'previewSplit': 'vertical',
        \       'previewFloatingTitle': 'Preview',
        \       'highlights': {
        \         'floating': 'Normal',
        \         'floatingBorder': 'Normal',
        \         'selected': 'Visual',
        \        },
        \       'displaySourceName': "long",
        \       'floatingTitle': "ddu",
        \     }
        \   },
        \ })

  " https://github.com/Shougo/ddu-kind-file
  call ddu#custom#patch_global({
        \   'kindOptions': {
        \     'file': {
        \       'defaultAction': 'open',
        \     },
        \   }
        \ })

  " https://github.com/Shougo/ddu-filter-matcher_substring
  call ddu#custom#patch_global({
        \   'sourceOptions': {
        \     '_': {
        \       'matchers': ['matcher_substring'],
        \     },
        \   }
        \ })

  " https://github.com/Shougo/ddu-source-file
  call ddu#custom#patch_global({
      \ 'sources': [{'name': 'file', 'params': {}}],
      \ })

  " Set name specific configuration
  "call ddu#custom#patch_local('files', {
  "    \ 'sources': [
  "    \   {'name': 'file', 'params': {}},
  "    \   {'name': 'file_old', 'params': {}},
  "    \ ],
  "    \ })

  " Specify name
  "call ddu#start({'name': 'files'})

  " Specify source with params
  " NOTE: file_rec source
  " https://github.com/Shougo/ddu-source-file_rec
  "call ddu#start({'sources': [
  "    \ {'name': 'file_rec', 'params': {'path': expand('~')}}
  "    \ ]})
  nnoremap ff f
  nmap f [ddu]
  xmap f [ddu]
  nnoremap [ddu] <Nop>
  xnoremap [ddu] <Nop>

  nnoremap <silent> [ddu]b <Cmd>call ddu#start({
      \ 'name': 'current buffer dir',
      \ 'sources': [{'name': 'file'}],
      \ 'sourceOptions': {'file': #{ path: expand("%:p:h") },}
      \ })<CR>
  nnoremap <silent> [ddu]c <Cmd>call ddu#start({
      \ 'name': 'current',
      \ 'sources': [{'name': 'file'}],
      \ 'sourceOptions': {'file': #{ path: expand("./") },}
      \ })<CR>
  nnoremap <silent> [ddu]h <Cmd>call ddu#start({
      \ 'name': 'home',
      \ 'sources': [{'name': 'file'}],
      \ 'sourceOptions': {'file': #{ path: expand("~") },}
      \ })<CR>
  nnoremap <silent> [ddu]j <Cmd>call ddu#start({
      \ 'name': 'file_old',
      \ 'sources': [{'name': 'file_old'}]
      \ })<CR>
  nnoremap <silent> [ddu]l <Cmd>call ddu#start({
      \ 'name': 'line',
      \ 'sources': [{'name': 'line'}]
      \ })<CR>
  "nnoremap <silent> [ddu]p :Unite bookmark -default-action=cd -no-start-insert<CR>
  "nnoremap <expr> [ddu]g ':Unite grep:'. expand("%:h") . ':-r'
  "nnoremap <silent> [ddu]o :Unite -buffer-name=outline outline<CR>
  "nnoremap <silent> [ddu]q :Unite quickfix -no-start-insert<CR>
endfunction
call s:my_ddu_init()

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> <C-j>
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR>
        \ <Esc><Cmd>call ddu#ui#do_action('itemAction')<CR>
  inoremap <buffer><silent> <C-j>
        \ <Esc><Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> <C-j>
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
  nnoremap <buffer><silent> <CR>
        \ <Cmd>close<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>close<CR>
  inoremap <buffer><silent> <C-n>
        \ <Cmd>call ddu#ui#ff#execute("call cursor(line('.')+1,0)")<CR>
  inoremap <buffer><silent> <C-p>
        \ <Cmd>call ddu#ui#ff#execute("call cursor(line('.')-1,0)")<CR>
endfunction

" lsp{{{
lua<<EOF
local mason = require('mason')
mason.setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()
EOF
" }}}

" ---- check indent is valid {{{
function! s:validate_ruby_indent()
  let wsv = winsaveview()
  normal G
  let l:last = line('.')

  let l:invalid_linenum = []
  let l:i = 0
  while l:i != l:last
    let l:i = l:i + 1
    if empty(getline(l:i))
      continue
    endif
    if GetRubyIndent(l:i) != indent(l:i)
      call add(l:invalid_linenum, l:i)
    endif
  endwhile
  call winrestview(wsv)
  echomsg string(l:invalid_linenum)
endfunction
" }}}
command! ValidateRubyIndent call <SID>validate_ruby_indent()

"}}}
" ======== Each Language Setting {{{
" Java {{{
autocmd MyAutoCmd FileType java call s:java_my_settings()
function! s:java_my_settings()
  let g:java_highlight_functions = 'style'
  let g:java_highlight_all = 1
  let g:java_allow_cpp_keywords = 1
  setlocal ts=4
  setlocal sw=4
  setlocal noexpandtab
endfunction "}}}
" ruby {{{
autocmd MyAutoCmd FileType ruby call s:ruby_my_settings()

function! s:ruby_my_settings()
  " enable rsense
  "if exists('g:loaded_rsense') && filereadable(expand('~/.vim/bundle/rsense/bin/rsense'))
  "let g:rsenseUseOmniFunc = 1
  "let g:rsenseHome = expand('~/.vim/bundle/rsense')
  "let g:neocomplcache_omni_functions['ruby'] = 'RSenseCompleteFunction'
  "let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  "endif

  compiler ruby
  nmap <buffer> [make] :<C-u>make -c %<CR>
  setlocal ts=2
  setlocal sw=2
  setlocal expandtab
  inoremap <buffer> <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
        \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
        \ : smartchr#one_of(' = ', '=', ' == ',  '===', '=')
  inoremap <buffer> <expr> ~ smartchr#loop('~', ' =~ ', ' !~ ')
  inoremap <buffer> <expr> > <SID>sysid_match(["rubyString", "rubyStringDelimiter", "rubyComment"]) ? ">" : smartchr#loop(' > ', ' => ', ' >> ', '>')
  inoremap <buffer> <expr> < <SID>sysid_match(["rubyString", "rubyStringDelimiter", "rubyComment"]) ? "<" : smartchr#one_of(' < ', ' << ', '<')
  inoremap <buffer> <expr> + <SID>sysid_match(["rubyString", "rubyStringDelimiter", "rubyComment"]) ? "+" : smartchr#one_of(' + ', ' += ', '+')
  inoremap <buffer> <expr> - <SID>sysid_match(["rubyString", "rubyStringDelimiter", "rubyComment"]) ? "-" : smartchr#one_of(' - ', ' -= ', '-')
  inoremap <buffer> <expr> # <SID>sysid_match(["rubyString", "rubyStringDelimiter", "rubyComment"]) ? "#{}\<LEFT>" : "#"
  inoremap <buffer> <expr> " smartchr#one_of('"', "\"\"\<LEFT>")
  nnoremap <buffer> <Leader>v :ValidateRubyIndent<CR>
  let b:buffer_sticky = {
        \"#" : "#{}\<LEFT>", "(" : "()\<LEFT>",
        \"{" : "{}\<LEFT>", "[" : "[]\<LEFT>",
        \}
endfunction "}}}
" c  "{{{
autocmd MyAutoCmd FileType c call s:clang_my_settings()
function! s:clang_my_settings()
  setlocal ts=4
  setlocal sw=4
  setlocal noexpandtab
  nnoremap <buffer> <C-j> :Unite gtags/context<CR>
endfunction "}}}
" cpp  "{{{
autocmd MyAutoCmd FileType cpp call s:cpp_my_settings()
function! s:cpp_my_settings()
  setlocal ts=4
  setlocal sw=4
  setlocal noexpandtab
  nnoremap <buffer> <C-j> :Unite gtags/context<CR>
  let g:context_highlight_enable_source_name = ["current_word"]
endfunction "}}}
" scala  "{{{
autocmd MyAutoCmd FileType scala call s:scala_my_settings()
function! s:scala_my_settings()
  setlocal ts=4
  setlocal sw=4
  setlocal noexpandtab
  compiler scalac
  nmap <buffer> [make] :<C-u>make %<CR>
  inoremap <buffer> <expr> - smartchr#loop(' - ', '-')
  inoremap <buffer> <expr> = smartchr#loop(' = ', '=')
  inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
  inoremap <buffer> <expr> + smartchr#loop(' + ', '+')
  inoremap <buffer> <expr> > smartchr#loop(' > ', ' => ', ' -> ')
  inoremap <buffer> <expr> < smartchr#loop(' < ', ' <= ', ' <- ')
endfunction "}}}
" python  "{{{
autocmd MyAutoCmd FileType python call s:python_my_settings()
function! s:python_my_settings()
  setlocal ts=4
  setlocal sw=4
  setlocal expandtab
endfunction "}}}
" help "{{{
autocmd MyAutoCmd FileType help,ref-* call s:help_my_settings()
function! s:help_my_settings()
  nnoremap <silent> <buffer> <C-j> :bd<CR>
endfunction "}}}
" vimshell {{{
autocmd MyAutoCmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()
  imap <silent><buffer> <C-j> <Plug>(vimshell_exit):q<CR>
endfunction"}}}
" log, config {{{
autocmd MyAutoCmd FileType log,conf call s:log_config_my_settings()
function! s:log_config_my_settings()
  setlocal nomodeline
endfunction"}}}

"}}}
" ======== Post Process Setting {{{
" source localized vimrc"{{{
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
"}}}
unlet s:has_win
" }}}


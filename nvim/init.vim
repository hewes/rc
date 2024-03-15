let $VIMHOME = expand('<sfile>:p:h')

augroup MyAutoCmd
  autocmd!
augroup END
" ======== Util Function {{{
function! s:mkdir(file, ...)
  let f = a:0 ? fnamemodify(a:file, a:1) : a:file
  if !isdirectory(f)
    call mkdir(f, 'p')
  endif
endfunction

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


"}}}
"
source $VIMHOME/debug.vim

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
set updatetime=500

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

" toggle configuration
nnoremap <silent> <expr> <SPACE> <SID>toggle_setting()
let s:toggle_map = {
      \ 'p' : 'paste',
      \ 'w' : 'wrap',
      \ 'n' : 'number',
      \ 'l' : 'list',
      \ 'h' : 'hlsearch',
      \ }
function! s:toggle_setting()
  let l:key = getchar()
  if has_key(s:toggle_map, nr2char(l:key))
    return ":set ". "inv". s:toggle_map[nr2char(l:key)] . "\n"
  else
    return "<SPACE>" . nr2char(l:key)
  endif
endfunction

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
"set t_Co=256
"set background=dark

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
      "let path_tcwd = empty(bufname) ? "" : substitute(fnamemodify(bufname, ":p"), gettabvar(a:tab_number, "cwd") . "/", "", "g")
      let path_tcwd = empty(bufname) ? "" : fnamemodify(bufname, ":p")
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
"
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

" }}}
"
" log, config {{{
autocmd MyAutoCmd FileType log,conf call s:log_config_my_settings()
function! s:log_config_my_settings()
  setlocal nomodeline
endfunction"}}}

" Plugin
source $VIMHOME/jetpack.vim

" ======== Post Process Setting {{{
" source localized vimrc"{{{
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
"}}}
unlet s:has_win
" }}}


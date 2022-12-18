" ======== Initialize Section {{{
if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
augroup END
"}}}
" ======== dein setting {{{
let g:dein#types#git#default_protocol = 'https'
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_parent_dir = s:dein_dir . '/repos/github.com/Shougo'
let s:dein_repo_dir = s:dein_repo_parent_dir . '/dein.vim'

if !isdirectory(s:dein_repo_parent_dir)
  echomsg string("mkdir ". s:dein_repo_parent_dir)
  call mkdir(s:dein_dir . '/repos/github.com/Shougo', 'p')
endif

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    echomsg string("dein is not installed, clone from github")
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  "call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif

if dein#check_install()
  call dein#install()
endif
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
set backupdir=./.backup,~/.backup
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
if exists('&ambiwidth')
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
  highlight link uniteSource__Gtags_Path Directory
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
" ======== My Misc Setting {{{
" command window setting commands --- {{{
autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
  nnoremap <buffer> <C-j> :<C-u>quit<CR>
  inoremap <buffer> <C-j> <ESC>:<C-u>quit<CR>
  let b:neocomplete_sources = ['vim']
  startinsert!
endfunction
" }}}
" diff commands --- {{{
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! -bar ToggleDiff if &diff | execute 'windo diffoff'  | else
      \                           | execute 'windo diffthis' | endif

" }}}
function! s:get_cd_project_name() " project name related to the current directory {{{
  if fnamemodify(t:cwd, ":p") == fnamemodify("~/", ":p")
    return "[home]"
  endif
  if !exists('g:unite_source_bookmark_directory')
    return ''
  endif
  if !filereadable(g:unite_source_bookmark_directory . '/default')
    return ''
  endif
  for line in readfile(g:unite_source_bookmark_directory . '/default')
    let match = matchlist(line, '^\([^\t]*\)\t\([^\t]*\)\t\t')
    if empty(match)
      continue
    endif
    if match[2] == t:cwd .'/'
      return '['. match[1] .']'
    endif
  endfor
  return ''
endfunction
" }}}
function! s:refresh_project() " update GTAGS and tags{{{
  let l:tags = []
  if filereadable("tags") && executable('ctags')
    call add(l:tags, 'ctags')
    call s:system("ctags -R")
  endif
  if filereadable("GTAGS") && executable('gtags')
    call add(l:tags, 'gtags')
    call s:system("gtags -i")
  endif
  echo 'updating ' . join(l:tags, ', ') . '...'
endfunction
"}}}
command! RefreshProject call s:refresh_project()
function! s:init_project() " generates GTAGS and tags{{{
  let l:tags = []
  if executable('ctags')
    call add(l:tags, 'ctags')
    call s:system("ctags -R")
  endif
  if executable('gtags')
    call add(l:tags, 'gtags')
    call s:system("gtags -i")
  endif
  echo 'generate ' . join(l:tags, ', ') . '...'
endfunction
command! InitProject call s:init_project()
" }}}
" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
command! -complete=dir -nargs=? TabpageCD
      \ execute 'cd' fnameescape(<q-args>)
      \| call s:init_tab_page(getcwd(), 1)

function! s:init_tab_page(chdir, force)
  if !exists('t:cwd') || a:force
    let t:cwd = a:chdir
  endif
  if !exists('t:project') || a:force
    let t:project = s:get_cd_project_name()
  endif
  if !exists('t:local_setting') || a:force
    let t:local_setting = 1
    if exists("g:localrc_name") && filereadable(t:cwd. "/" . g:localrc_name)
      execute "source " . t:cwd . "/" . g:localrc_name
    endif
  endif
endfunction
let g:localrc_name = ".project.vimrc"

augroup MyAutoCmd
  autocmd VimEnter *
        \ let g:default_current_dir = getcwd()
        \| call s:init_tab_page(g:default_current_dir, 0)

  autocmd TabEnter *
        \ call s:init_tab_page(g:default_current_dir, 0)
        \| execute 'cd' fnameescape(t:cwd)
augroup END
"}}}
" Insert Mode <C-k> -- kill line from current to eol "{{{
func! s:kill_line()
  let curcol = col('.')
  if curcol == col('$')
    join!
    call cursor(line('.'), curcol)
  else
    normal! D
  endif
endfunc
inoremap <C-k>  <C-o>:<C-u>call <SID>kill_line()<CR>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
"}}}
" Normal Mode <C-k> -- kill buffer, not close window {{{
" http://nanasi.jp/articles/vim/kwbd_vim.html
:com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn
nnoremap <C-k>  :Kwbd<CR>
"}}}
" :Rename, :Move, :Delete -- operate current file command {{{
command! -nargs=1 -bang -bar -complete=file Rename
      \        call s:move(<q-args>, <q-bang>, expand('%:h'))
command! -nargs=1 -bang -bar -complete=file Move
      \        call s:move(<q-args>, <q-bang>, getcwd())
function! s:move(file, bang, base)
  let pwd = getcwd()
  cd `=a:base`
  try
    let from = expand('%:p')
    let to = simplify(expand(a:file))
    let bang = a:bang
    if isdirectory(to)
      let to .= '/' . fnamemodify(from, ':t')
    endif
    if filereadable(to) && !bang
      echo '"' . to . '" is exists. Overwrite? [yN]'
      if nr2char(getchar()) !=? 'y'
        echo 'Cancelled.'
        return
      endif
      let bang = '!'
    endif
    let dir = fnamemodify(to, ':h')
    call s:mkdir(dir)
    execute 'saveas' . bang '`=to`'
    call delete(from)
  finally
    cd `=pwd`
  endtry
endfunction

command! -nargs=? -bang -bar -complete=file Delete
      \ call s:delete_with_confirm(<q-args>, <bang>0)
function! s:delete_with_confirm(file, force)
  let file = a:file ==# '' ? expand('%') : a:file
  if !a:force
    echo 'Delete "' . file . '"? [y/N]:'
  endif
  if a:force || nr2char(getchar()) ==? 'y'
    call delete(file)
    echo 'Deleted "' . file . '"!'
  else
    echo 'Cancelled.'
  endif
endfunction
"}}}
" ----- source vimrc when write {{{
if !has('gui_running') && !(has('win32') || has('win64'))
  autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
  autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
        \if has('gui_running') | source $MYGVIMRC
  autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif
" }}}
" ---- sticky shift "{{{
inoremap <expr> ;  <SID>sticky_func()
cnoremap <expr> ;  <SID>sticky_func()
snoremap <expr> ;  <SID>sticky_func()

let g:us_sticky_table = {
      \',' : '<', '.' : '>', '/' : '?',
      \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
      \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
      \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
      \}
let g:jp_sticky_table = {
      \',' : '<', '.' : '>', '/' : '?',
      \'1' : '!', '2' : "\"" , '3' : '#', '4' : '$', '5' : '%',
      \'6' : '&', '7' : "'", '8' : '(', '9' : ')', '-' : '=', '^' : '~',
      \';' : '+', '[' : '{', ']' : '}', '@' : '`'  , ':' : '*', '\' :  '_' ,
      \}
let g:sticky_table = g:jp_sticky_table
function! s:sticky_func()
  let l:special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>",
        \"\<TAB>" : "\<C-o>W" , "\<BS>" : "\<C-o>B"
        \}

  let l:key = getchar()
  if nr2char(l:key) =~ '\l'
    return toupper(nr2char(l:key))
  elseif has_key(g:sticky_table, nr2char(l:key))
    return g:sticky_table[nr2char(l:key)]
  elseif has_key(l:special_table, nr2char(l:key))
    return l:special_table[nr2char(l:key)]
  elseif exists("b:buffer_sticky") && has_key(b:buffer_sticky, nr2char(l:key))
    return b:buffer_sticky[nr2char(l:key)]
  else
    return ''
  endif
endfunction
"}}}
" ---- toggle vim setting "{{{
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
" }}}
" ---- reopen/write file with specified encoding {{{
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>
command! -bang -complete=file -nargs=? WUtf8 write<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? WSjis write<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? WEuc write<bang> ++enc=eucjp <args>
" }}}
" ---- move caret to next delimiter {{{
function! s:skip_position()
  let pos = getpos('.')
  let l:eol_col = len(getline('.'))
  if l:eol_col == pos[2] && pos[3] > 0
    " if caret is at eol, feed next line, and move to right
    let pos[1] += 1
    let pos[2] = 0
    let pos[3] = 0
  else
    let match = search('[,(){}\[\]"]', 'c', line('.'))
    let pos = getpos('.')
    if match == 0
      " if delimeter is not found at the current line, move to eol
      let pos[2] = l:eol_col + 1
      let pos[3] = 0
    else
      " if delimeter is found, move caret to next col of the delimeter
      let pos[2] += 1
      let pos[3] = 0
    endif
  endif
  call setpos('.', pos)
  return
endfunction
inoremap <Plug>(skip_position) <C-o>:call <SID>skip_position()<CR>
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

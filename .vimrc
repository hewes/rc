" ======== NeoBundle Setting {{{
set nocompatible
filetype off
if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc('~/.vim/bundle/')
endif
NeoBundle 'm2ym/rsense.git'
NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat.git'
NeoBundle 'h1mesuke/vim-alignta.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'thinca/vim-ref.git'
NeoBundle 'thinca/vim-qfreplace.git'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'othree/eregex.vim.git'
NeoBundle 'Shougo/neobundle.vim.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/unite-build.git'
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/vimfiler.git'
NeoBundle 'Shougo/vimproc.git'
NeoBundle 'Shougo/vim-vcs.git'
NeoBundle 'Shougo/neocomplcache-snippets-complete.git'
NeoBundle 'Shougo/unite-outline.git'
NeoBundle 'kmnk/vim-unite-svn.git'
NeoBundle 'kana/vim-smartchr.git'
NeoBundle 'kana/vim-altercmd'
NeoBundle 'tsukkee/unite-tag.git'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'tyru/eskk.vim'
NeoBundle 'ujihisa/unite-colorscheme.git'
NeoBundle 'vim-scripts/DrawIt.git'
NeoBundle 'vim-scripts/wombat256.vim.git'
NeoBundle 'rosstimson/scala-vim-support.git'

filetype plugin indent on
" }}}
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
  let l:sysid = synIDattr(synID(line('.'), col('.'), 0), 'name')
  if index(a:sys_ids, l:sysid) >= 0
    return 1
  else
    return 0
  endif
endfunction

"}}}
" ======== Basic Setting {{{
" Initialize my vimrc augroup.
augroup MyAutoCmd
    autocmd!
augroup END

let s:has_win = has('win32') || has('win64')

" Exchange path separator.
if s:has_win
  set shellslash
endif
set shell=zsh

" abosorb difference between windows and Linux
let dotvim = $HOME . "/.vim"

" split window direction
set splitbelow
set splitright

set hidden

" default indent setting
set autoindent
set cindent
" tab setting
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set smartindent

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
set noimdisable
set noimcmdline
set iminsert=1
set imsearch=1

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

autocmd MyAutoCmd FileType * set formatoptions-=ro

" ------ The encoding setting {{{
" Use utf-8.
if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif

" Must after set of 'encoding'.
scriptencoding utf-8

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
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
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
" ---- insert mode {{{
"inoremap <C-l> <ESC>
inoremap <C-e> <END>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap jj <ESC>
inoremap <ESC> <ESC>
inoremap <C-l> <C-o>w
" }}}
" ---- normal mode {{{
nnoremap <silent> <Leader><Leader> :bnext<CR>
nnoremap <Leader>a :Ref<SPACE>alc<SPACE>

nnoremap <Space> <Nop>
nnoremap <SPACE><SPACE> <C-^>
" Quick save and quit.
nnoremap <silent> <Space>w :<C-u>update<CR>
nnoremap <silent> <Space>W :<C-u>update!<CR>
nnoremap <silent> <Space>q :<C-u>quit<CR>
nnoremap <silent> <Space>Q :<C-u>quit!<CR>
nnoremap ,t :tabnew<SPACE>
nnoremap Y y$
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap <expr> sw ':%s/\<' . expand('<cword>') .'\>/'
"nnoremap <C-l> <C-g>
nnoremap <C-h> gT
nnoremap <C-l> gt

" tag shortcut
nnoremap t <Nop>
nnoremap tt <C-]>
nnoremap tj <C-u>:tag<CR>
nnoremap tk <C-u>:pop<CR>
nnoremap tl <C-u>:tags<CR>
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
set previewheight=32

" ----- color {{{
set t_Co=256
set background=dark

function! s:set_highlight()
  hi CursorLine term=reverse cterm=none ctermbg=233
  hi CursorColumn term=reverse cterm=none ctermbg=233
  "hi Pmenu ctermbg=darkgrey ctermfg=white
  "hi PmenuSel ctermbg=grey ctermfg=black
  "hi PmenuSbar ctermbg=0 ctermfg=6
  hi MatchParen term=NONE cterm=NONE ctermfg=NONE ctermbg=52 guifg=NONE guibg=red
  hi IncSearch term=NONE cterm=NONE ctermfg=white ctermbg=52
  hi StatusLine term=NONE cterm=NONE ctermfg=white ctermbg=darkred
  highlight CurrentWord term=NONE ctermbg=52 ctermfg=NONE guibg=darkred
  highlight Indent term=NONE ctermbg=238 ctermfg=NONE guibg=#444444 guifg=NONE
endfunction

autocmd MyAutoCmd ColorScheme * call s:set_highlight()

colorscheme wombat256mod

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

" change cursor shape
if &term == "xterm-256color"
    "let &t_SI .= "\eP\e[5 q\e\\"
    "let &t_EI .= "\eP\e[1 q\e\\"
elseif &term == "xterm"
    "let &t_SI .= "\e[5 q"
    "let &t_EI .= "\e[1 q"
endif

let s:slhlcmd = ''
let g:hi_insert  =  'highlight StatusLine ctermfg = white ctermbg = 138 cterm = none'
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
" }}}

" ----- Status line setting {{{
" status line format
if v:version < 703
  function! Dirname()
    let project = get(t:, 'project', "")
    if !empty(project)
      let project = project . "\ "
    end
    return project . "%f"
  endfunction
else
  function! Dirname()
    return "%f"
  endfunction
end

function! GetVCSInfo()
  "if exists("g:loaded_vcs")
    "return vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")
  "else
  if exists("g:loaded_fugitive")
    return fugitive#statusline()
  endif
  "endif
endfunction

function! MyStatusLine()
  return "\%{GetVCSInfo()}". Dirname(). "\ %m%r%h%w\%=[FORMAT=%{&ff}]\[TYPE=%Y]\%{'[ENC='.(&fenc!=''?&fenc:&enc).']'}[%05l/%L:%04c]"
endfunction

set statusline=%!MyStatusLine()
"set statusline=%F%m%r%h%w\%=[FORMAT=%{&ff}]\[TYPE=%Y]\%{'[ENC='.(&fenc!=''?&fenc:&enc).']'}[%05l/%L:%04c]
"}}}

" ----- Tab label setting {{{ 
function! BufnameOnTab(tab_num)
  let buflist  =  tabpagebuflist(a:tab_num)
  let winnr  =  tabpagewinnr(a:tab_num)
  return bufname(buflist[winnr - 1]) 
endfunction

if v:version < 703
  function! MyTabLabel(n)
    return BufnameOnTab(a:n)
  endfunction
else
  function! MyTabLabel(n)
    let bufname   = BufnameOnTab(a:n)
    let path_tcwd = empty(bufname) ? "" : substitute(fnamemodify(bufname, ":p"), gettabvar(a:n, "cwd") . "/", "", "g")
    let project   = gettabvar(a:n, "project")
    return empty(project) ? path_tcwd : project . ' ' .  path_tcwd
  endfunction
end

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '%' . (i+1) . 'T' 
    let s .= ' ' . (i+1) . (1==getwinvar(i+1,'&modified')?'[+]':'') . ' %{MyTabLabel(' . (i+1) . ')} '
  endfor
  let s .= '%#TabLineFill#%T'
  return s
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
" }}}
" ======== My Misc Setting {{{
" diff commands --- {{{
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! -bar Diff if &diff | execute 'windo diffoff'  | else
\                           | execute 'windo diffthis' | endif
" }}}

function! s:GetCDProjectName() " project name related to the current directory {{{
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

let g:default_current_dir = $HOME
" }}}

" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
call altercmd#load()
command! -complete=dir -nargs=? TabpageCD
      \ execute 'cd' fnameescape(<q-args>)
      \| call s:InitTabpage(getcwd(), 1)

function! s:InitTabpage(chdir, force)
  if !exists('t:cwd') || a:force
    let t:cwd = a:chdir
  endif
  if !exists('t:project') || a:force
    let t:project = s:GetCDProjectName()
  endif
endfunction

AlterCommand cd TabpageCD
command! -nargs=0 CD silent execute 'TabpageCD' unite#util#path2project_directory(expand('%:p'))

autocmd VimEnter,TabEnter *
      \ call s:InitTabpage(g:default_current_dir, 0)
      \| execute 'cd' fnameescape(t:cwd)
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

" ---- auto highlight{{{
" init var {{{
let g:auto_highlights = {}
let g:auto_highlight_disable_file_type = ["", "unite", "txt", "tmp"]
let g:enable_auto_highlight = 1
"}}}

" util function {{{
function! s:EscapeText( text )
  return substitute( escape(a:text, '\' . '^$.*[~'), "\n", '\\n', 'ge' )
endfunction

function! s:compare_source(i1, i2)
  return a:i1.priority == a:i2.priority ? 0 : a:i1.priority > a:i2.priority ? 1 : -1
endfunction

function! s:init_window_auto_highlight()
  let l:info = {}
  for highlight_kind in keys(g:auto_highlights)
    let l:info[highlight_kind] ={
          \ 'current_match_pattern' : '',
          \ 'current_match_id' : -1,
          \}
  endfor
  return l:info
endfunction

function! s:define_auto_highlight_source(src)
  if !has_key(g:auto_highlights, a:src.highlight)
    let g:auto_highlights[a:src.highlight] = {
          \ 'enable' : 1,
          \ 'sources' : [],
          \}
  endif
  call add(g:auto_highlights[a:src.highlight].sources, a:src)
  call sort(g:auto_highlights[a:src.highlight].sources, 's:compare_source')
endfunction
"}}}

" commands {{{
function! s:start_highlight()
  if !get(g:, "enable_auto_highlight", 0) || index(get(g:, 'auto_highlight_disable_file_type', []), &filetype) >= 0
    return
  endif
  if !exists('w:auto_highlight_info')
    let w:auto_highlight_info = s:init_window_auto_highlight()
  endif
  for [item, value] in items(g:auto_highlights)
    for src in value.sources
      let l:pattern = src.pattern()
      if !empty(l:pattern)
        let l:target = w:auto_highlight_info[item]
        if l:target['current_match_pattern'] != l:pattern
          call s:ClearHighlight(item)
          let l:target['current_match_pattern'] = l:pattern
          let l:target['current_match_id'] = matchadd(item, l:pattern, 0)
        endif
        break
      endif
    endfor
  endfor
endfunction

function! s:ClearHighlight(kind)
  if exists('w:auto_highlight_info')
    if w:auto_highlight_info[a:kind].current_match_id >= 0
      call matchdelete(w:auto_highlight_info[a:kind].current_match_id)
      let w:auto_highlight_info[a:kind].current_match_id = -1
      let w:auto_highlight_info[a:kind].current_match_pattern = ''
    endif
  endif
endfunction

function! s:toggle_auto_highlight()
  let g:enable_auto_highlight = !get(g:, "enable_auto_highlight", 0)
  call s:CheckEnableHighlightCurrentWord()
endfunction

function! s:CheckEnableHighlightCurrentWord()
  if !g:enable_auto_highlight
    for kind in keys(g:auto_highlights)
      call s:ClearHighlight(kind)
  endfor
  endif
endfunction

command! -bar ToggleCurrentHighlight call s:toggle_auto_highlight()
command! -bar CurrentHighlight call s:start_highlight()

augroup HighlightCurrent
  autocmd!
  autocmd WinEnter,BufEnter * call s:CheckEnableHighlightCurrentWord()
  autocmd CursorHold,CursorHoldI * call s:start_highlight()
augroup END
"}}}

" define sourcers {{{
" current word highlight {{{
let s:cword_highlight = {
      \ 'name': 'current_word',
      \ 'highlight': 'CurrentWord',
      \ 'priority': 10,
      \}

function! s:cword_highlight.pattern()
  let l:cwd = expand('<cword>')
  if empty(l:cwd)
    return ''
  else
    let l:regexp = s:EscapeText(l:cwd)
    return l:cwd =~# '^\k\+$' ? '\<' . l:regexp . '\>' : l:regexp
  endif
endfunction
call s:define_auto_highlight_source(s:cword_highlight)
" }}}

" matchit highlight {{{
let s:matchit_highlight = {
      \ 'name': 'matchit',
      \ 'highlight': 'CurrentWord', 
      \ 'priority': 9,
      \}

function! s:InitMatchit()
  if !exists('b:match_words')
    return
  endif
  let l:mw = filter(split(b:match_words, ',\|:'), 'v:val !~ "^[(){}[\\]]$"')
  let b:reserved_regexp = join(l:mw, '\|')
  let mwre = '\%(' . b:reserved_regexp . '\)'
  let b:mwre = substitute(mwre, "'", "''", 'g')
endfunction

function! s:matchit_highlight.pattern()
  if !exists('b:match_words')
    return ''
  endif
  if !exists('b:reserved_regexp')
    call s:InitMatchit()
  endif
  if expand("<cword>") !~ b:reserved_regexp
    return ''
  endif
  let lcs = []
  let wsv = winsaveview()
  while 1
    exe 'normal %'
    let lc = {'line': line('.'), 'col': col('.')}
    if len(lcs) > 0 && (lcs[0] == lc || lcs[-1] == lc)
      break
    endif
    call add(lcs, lc)
  endwhile
  call winrestview(wsv)

  call map(lcs, '"\\%" . v:val.line . "l\\%" . v:val.col . "c"')
  let lcre = join(lcs, '\|')
  " final \& part of the regexp is a hack to improve html
  return '.*\%(' . lcre . '\).*\&' . b:mwre
  "return '.*\%(' . lcre . '\).*\&' . b:mwre . '\&\% (<\_[^>]\+>\|.*\)'
endfunction
call s:define_auto_highlight_source(s:matchit_highlight)
" }}}

" indent highlight {{{
let s:indent_highlight = {
      \ 'name': 'indent',
      \ 'highlight': 'Indent', 
      \ 'priority': 10,
      \}

function! s:indent_highlight.pattern()
  let l:line = getline('.')
  let l:indent = matchstr(l:line, '^\zs\s\+\ze\S')
  let l:len = len(l:indent) - 1
  if l:len > 0
    return '^\s\{'. l:len . '}\zs\s\ze'
  else
    return '^\zs\s\ze'
  endif
endfunction
call s:define_auto_highlight_source(s:indent_highlight)
" }}}
"}}}
set updatetime=1000
" }}}

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

" ---- reopen/write file with specified encoding {{{
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>
command! -bang -complete=file -nargs=? WUtf8 write<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? WSjis write<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? WEuc write<bang> ++enc=eucjp <args>
" }}}

" define unite gtags source{{{
" Initialize variable {{{
let s:global_cmd = empty($GTAGSGLOBAL) ? "global" : $GTAGSGLOBAL

if !exists("s:unite_source_shell_quote")
  if has("win32") || has("win16") || has("win95")
    let s:unite_source_shell_quote = '"'
  else
    let s:unite_source_shell_quote = "'"
  endif
endif
" }}}

" global cmd result option formats {{{
let s:format = {
      \ "ctags-x" : {},
      \ "ctags-mod" : {}
      \ }

function! s:format["ctags-x"].func(line)
  let l:items = matchlist(a:line, '\(\d\+\)\s\+\(.*\.\S\+\) \(.*\)$')
  return {
        \  "kind": "jump_list",
        \  "word" : l:items[0],
        \  "action__path" : l:items[2],
        \  "action__line" : l:items[1],
        \  "action__text" : l:items[3],
        \}
endfunction

function! s:format["ctags-mod"].func(line)
  let l:items = matchlist(a:line, '^\([^	]\+\)[	]\+\(\d\+\)[	]\+\(.\+\)$')
  return {
        \  "kind": "jump_list",
        \  "word" : l:items[0],
        \  "action__path" : l:items[1],
        \  "action__line" : l:items[2],
        \  "action__text" : l:items[3],
        \}
endfunction
" }}}

" define sources {{{
let s:def_source  = {
      \ 'name'       : 'gtags/def',
      \ 'description': 'candidates from heading list',
      \ 'syntax' : 'uniteSource__Gtags',
      \ 'hooks'      : {}, 'action_table': {}, 'alias_table': {}, 'default_action': {},
      \ }
let s:ref_source = copy(s:def_source)
let s:context_source = copy(s:def_source)

" gtags/context source {{{
let s:context_source.name = 'gtags/context'
function! s:context_source.gather_candidates(args, context)
  if empty(a:args)
    let l:pattern = expand("<cword>")
  else
    let l:pattern = a:args[0]
  endif
  if empty(l:pattern)
    return []
  endif
  let l:option = "--from-here=\"" . line('.') . ":" . expand("%") . "\""
  return s:result2unite('gtags/def', s:ExecGlobal('', l:option, l:pattern))
endfunction

function! s:context_source.hooks.on_syntax(args, context)
  return s:on_syntax(a:args, a:context)
endfunction
"}}}

" gtags/def source {{{
let s:def_source.name = 'gtags/def'
function! s:def_source.gather_candidates(args, context)
  if empty(a:args)
    let l:pattern = expand("<cword>")
  else
    let l:pattern = a:args[0]
  endif
  if empty(l:pattern)
    return []
  endif
  return s:result2unite('gtags/def', s:ExecGlobal('d', '', l:pattern))
endfunction

function! s:def_source.hooks.on_syntax(args, context)
  return s:on_syntax(a:args, a:context)
endfunction
"}}}

" gtags/ref source {{{
let s:ref_source.name = 'gtags/ref'
function! s:ref_source.gather_candidates(args, context)
  let l:pattern = expand("<cword>")
  if empty(l:pattern)
    return []
  endif
  return s:result2unite('gtags/ref', s:ExecGlobal('r', '', l:pattern))
endfunction

function! s:ref_source.hooks.on_syntax(args, context)
  return s:on_syntax(a:args, a:context)
endfunction
" }}}

" gtags/completion source {{{
let s:symbol_source  = {
      \  'name'       : 'gtags/symbol',
      \  'description': 'candidates from heading list',
      \  'hooks'      : {},  'alias_table': {},
      \ }
function! s:symbol_source.gather_candidates(args, context)
  let l:symbols = split(s:ExecGlobal('c', '', ''), '\n')
  return map(l:symbols, '{
        \   "source" : "gtags/symbol",
        \   "kind"   : "gtags_symbol",
        \   "word"   : v:val,
        \ }')
endfunction

call unite#define_source(s:def_source)
call unite#define_source(s:ref_source)
call unite#define_source(s:context_source)
call unite#define_source(s:symbol_source)
" }}}
"}}}

" common function{{{
function! s:ExecGlobal(option, long_option, pattern)
  " Execute global(1) command and write the result to a temporary file.
  let l:isfile = 0
  let l:option = ''

  if a:option =~ 'f'
    let l:isfile = 1
    if filereadable(a:pattern) == 0
      call unite#util#print_error('File ' . a:pattern . ' not found.')
      return []
    endif
  endif
  if a:long_option != ''
    let l:option = a:long_option . ' '
  endif
  let l:option = "-q" . a:option
  if l:isfile == 1
    let l:cmd = s:global_cmd . ' ' . l:option . ' ' . s:unite_source_shell_quote . a:pattern . s:unite_source_shell_quote
  else
    let l:cmd = s:global_cmd . ' ' . l:option . 'e ' . s:unite_source_shell_quote . a:pattern . s:unite_source_shell_quote
  endif
  let options = exists("g:unite_source_gtags_result_option") ? [g:unite_source_gtags_result_option] : ["ctags-mod", "ctags-x"]
  for result_option in options
    let l:exe_cmd = l:cmd . " --result=" . result_option
    let l:result = system(l:exe_cmd)
    if v:shell_error != 0
      if v:shell_error == 2
        " not supported option try next option
        continue
      elseif v:shell_error == 3
        call unite#util#print_error('GTAGS not found.')
      else
        call unite#util#print_error('global command failed. command line: ' . l:cmd)
      endif
      return ''
    endif
    if !empty(l:result)
      if !empty(l:result) && !exists("g:unite_source_gtags_result_option")
        let g:unite_source_gtags_result_option = result_option
      endif
      return l:result
    endif
  endfor
  return ''
endfunction

function! s:result2unite(source, result)
  if empty(a:result)
    return []
  endif
  return map(split(a:result, '\r\n\|\r\|\n'),
        \ 'extend(s:format[g:unite_source_gtags_result_option].func(v:val), {"source" : a:source})')
endfunction

function! s:on_syntax(args, context)
  syntax match uniteSource__Gtags_Line /\zs\d\+\ze\s\{2,}.\+$/
        \ contained containedin=uniteSource__Gtags
  highlight default link uniteSource__Gtags_Line Number
  syntax match uniteSource__Gtags_Path /\zs.\+\ze\s\{2}\d\+/
        \ contained containedin=uniteSource__Gtags
  highlight default link uniteSource__Gtags_Path Statement
endfunction


let s:kind = {
      \ 'name' : 'gtags_symbol',
      \ 'default_action' : 'list_definitions',
      \ 'action_table': {},
      \}

" Actions
let s:kind.action_table.list_refereces = {
      \ 'description' : 'Unite gtags/ref',
      \ 'is_selectable' : 0,
      \ }

function! s:kind.action_table.list_refereces.func(candidate)
  echomsg string(a:candidate)
  execute 'Unite gtags/ref:'. a:candidate.word
endfunction

let s:kind.action_table.list_definitions = {
      \ 'description' : 'Unite gtags/def',
      \ 'is_selectable' : 0,
      \ }

function! s:kind.action_table.list_definitions.func(candidate)
  echomsg string(a:candidate)
  execute 'Unite gtags/def:'. a:candidate.word . ' -immediately'
endfunction

call unite#define_kind(s:kind)
" }}}

" }}}
"}}}
" ======== Plugin Settings {{{
" ----- neocomplcache.vim {{{
" keymapping {{{
" neocomplcache prefix
nmap <Leader>c [neocomplcache]
nnoremap [neocomplcache]e :<C-u>NeoComplCacheEditSnippets<CR>
inoremap <expr><C-l> neocomplcache#complete_common_string()
" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-c> neocomplcache#complete_common_string()

" expand snippets by TAB
imap <silent> <expr> <Tab> <SID>tab_wrapper()
smap  <TAB> <Plug>(neocomplcache_snippets_expand)
function! s:tab_wrapper()
  if neocomplcache#sources#snippets_complete#expandable()
    return "\<Plug>(neocomplcache_snippets_jump)"
  elseif pumvisible()
    return "\<C-y>"
  elseif (!exists('b:smart_expandtab') || b:smart_expandtab) &&
  \   !&l:expandtab && !search('^\s*\%#', 'nc')
    return repeat(' ', &l:tabstop - (virtcol('.') - 1) % &l:tabstop)
  endif
  return "\<Tab>"
endfunction
" }}}

" snippets directory
let g:neocomplcache_snippets_dir = $HOME. '/.vim/snippets'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_max_list = 10000
let g:neocomplcache_max_keyword_width = 100
let g:neocomplcache_enable_prefetch = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_auto_completion_start_length = 1
let g:neocomplcache_plugin_completion_length_list = {
\   'snippets_complete' : 1,
\   'buffer_complete' : 2,
\   'syntax_complete' : 2,
\   'tags_complete' : 3,
\ }

let g:neocomplcache_vim_completefuncs = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimShellExecute' : 'vimshell#complete#vimshell_execute_complete#completefunc',
      \ 'VimShellTerminal' : 'vimshell#complete#vimshell_execute_complete#completefunc', 
      \ 'VimShellInteractive' : 'vimshell#complete#vimshell_execute_complete#completefunc',
      \ 'VimFiler' : 'vimfiler#complete',
      \}

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'ruby' : $HOME.'/.vim/dict/ruby.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ }

let g:neocomplcache_omni_functions = {
      \ 'python' : 'pythoncomplete#Complete',
      \ 'ruby' : 'rubycomplete#Complete',
      \ }


" Enable omni completion.
autocmd MyAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd MyAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd MyAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd MyAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:rsenseUseOmniFunc = 1
if filereadable(expand('~/.vim/bundle/rsense/bin/rsense'))
  let g:rsenseHome = expand('~/.vim/bundle/rsense/bin/rsense')

  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"}}}

" unite.vim "{{{
" map ff as default f
nnoremap ff f
" map f as unite prefix key
nmap f [unite]
xmap f [unite]
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
" mapping for Unite functions
nnoremap <silent> [unite]u :Unite -buffer-name=files file<CR>
nnoremap <silent> [unite]m :Unite -buffer-name=file file_mru<CR>
nnoremap <silent> [unite]r :Unite file_rec<CR>
nnoremap [unite]R :Unite ref/
nnoremap <silent> [unite]b :UniteWithBufferDir -no-split -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]c :UniteWithCurrentDir -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]t :Unite tab<CR>
nnoremap <silent> [unite]T :Unite tag<CR>
nnoremap <silent> [unite]y :Unite register<CR>
nnoremap <silent> [unite]a :UniteBookmarkAdd<CR>
nnoremap <silent> [unite]p :Unite bookmark -default-action=cd -no-start-insert<CR>
"nnoremap <silent> [unite]j :Unite jump<CR>
" Explore home dir
nnoremap <silent> <expr> [unite]h ':UniteWithInput -buffer-name=files file file/new -input='. $HOME .'/<CR>'
nnoremap <silent> [unite]j :Unite buffer_tab -no-start-insert<CR>
nnoremap <silent> [unite]l :Unite -auto-preview -no-split line<CR>
nnoremap <expr> [unite]g ':Unite grep:'. expand("%:h") . ':-r'
nnoremap <silent> [unite]* :UniteWithCursorWord line<CR>
nnoremap <silent> [unite]o :Unite -buffer-name=outline -auto-preview -no-split outline<CR>
nnoremap <silent> [unite]q :Unite qf -no-start-insert<CR>
nnoremap [unite]s<SPACE> :Unite svn/
nnoremap <silent> [unite]sd :Unite svn/diff<CR>
nnoremap <silent> [unite]sb :Unite svn/blame<CR>
nnoremap <silent> [unite]ss :Unite svn/status<CR>
nnoremap <C-j> :Unite gtags/context -auto-preview<CR>

let g:unite_enable_ignore_case = 1
noremap [unite]] :<C-u>Unite -immediately -no-start-insert tag:<C-r>=expand('<cword>')<CR><CR>
let g:unite_enable_smart_case = 1
let g:unite_enable_start_insert = 1
let g:unite_enable_split_vertically  =  0
let g:unite_source_file_mru_limit  =  300
let g:unite_source_file_rec_min_cache_files = 300
let g:unite_source_file_rec_max_depth = 10
let g:unite_kind_openable_cd_command = 'TabpageCD'
let g:unite_kind_openable_lcd_command = 'TabpageCD'
let g:unite_winheight = 20

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  nnoremap <silent><buffer> <C-o> :call unite#mappings#do_action('tabopen')<CR>
  nnoremap <silent><buffer> <C-v> :call unite#mappings#do_action('vsplit')<CR>
  nnoremap <silent><buffer> <C-s> :call unite#mappings#do_action('split')<CR>
  nnoremap <silent><buffer> <C-r> :call unite#mappings#do_action('rec')<CR>
  nnoremap <silent><buffer> <C-f> :call unite#mappings#do_action('preview')<CR>
  inoremap <silent><buffer> <C-o> <Esc>:call unite#mappings#do_action('tabopen')<CR>
  inoremap <silent><buffer> <C-v> <Esc>:call unite#mappings#do_action('vsplit')<CR>
  inoremap <silent><buffer> <C-s> <Esc>:call unite#mappings#do_action('split')<CR>
  inoremap <silent><buffer> <C-r> <Esc>:call unite#mappings#do_action('rec')<CR>
  inoremap <silent><buffer> <C-e> <Esc>:call unite#mappings#do_action('edit')<CR>
  inoremap <silent><buffer> <C-f> <C-o>:call unite#mappings#do_action('preview')<CR>
  " I hope to use <C-o> and return to the selected item after action...
  imap <silent><buffer> <C-j> <Plug>(unite_exit)
  nmap <silent><buffer> <C-j> <Plug>(unite_exit)
  inoremap <silent><buffer> <SPACE> _
  inoremap <silent><buffer> _ <SPACE>
endfunction "}}}
"}}}

" smartchr.vim"{{{
inoremap <expr> , smartchr#one_of(', ', ',')
inoremap <expr> ? smartchr#one_of('?', '? ')

" Smart =.
inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
      \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
      \ : smartchr#one_of(' = ', '=', ' == ',  '=')
augroup MyAutoCmd
  autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
  autocmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop(' . ', '->', '.')
  autocmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')
  autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')

  autocmd FileType haskell,int-ghci
        \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
        \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
        \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
        \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
        \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
        \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')
  autocmd FileType sh,bash,vim,zsh
        \ inoremap = =
        \| inoremap , ,
  autocmd FileType scala
        \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
        \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
        \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
        \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')
  autocmd FileType eruby,yaml
        \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
        \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
augroup END
"}}}

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

" vimfiler.vim"{{{
"nmap <Leader>v <Plug>(vimfiler_switch)
"nnoremap <silent> <Leader>v :<C-u>VimFiler `=<SID>GetBufferDirectory()`<CR>
nnoremap <silent> <Leader>v :<C-u>VimFiler<CR>
nmap <Leader>ff <Plug>(vimfiler_switch)
nmap <Leader>si <Plug>(vimfiler_simple)
nmap <Leader>h :<C-u>edit %:h<CR>

" Set local mappings.
nmap <C-p> <Plug>(vimfiler_open_previous_file)
nmap <C-n> <Plug>(vimfiler_open_next_file)

call vimfiler#set_execute_file('vim', 'vim')
call vimfiler#set_execute_file('txt', 'vim')
let g:vimfiler_split_command = ''
let g:vimfiler_edit_command = 'tabedit'
let g:vimfiler_pedit_command = 'vnew'

let g:vimfiler_enable_clipboard = 0
let g:vimfiler_safe_mode_by_default = 1
let g:vimshell_cd_command = 'TabpageCD'

" Linux default.
let g:vimfiler_external_copy_directory_command = 'cp -r $src $dest'
let g:vimfiler_external_copy_file_command = 'cp $src $dest'
let g:vimfiler_external_delete_command = 'rm -r $srcs'
let g:vimfiler_external_move_command = 'mv $srcs $dest'

" Windows default.
let g:vimfiler_external_delete_command = 'system rmdir /Q /S $srcs'
let g:vimfiler_external_copy_file_command = 'system copy $src $dest'
let g:vimfiler_external_copy_directory_command = ''
let g:vimfiler_external_move_command = 'move /Y $srcs $dest'

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_detect_drives = ['C', 'D', 'E', 'F', 'G', 'H', 'I',
      \ 'J', 'K', 'L', 'M', 'N']

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()"{{{
" Overwrite settings.
endfunction"}}}
"}}}

" vimshell.vim"{{{
nnoremap <Leader>x :VimShellTab<CR>
let g:vimshell_user_prompt = 'getcwd()'
"}}}

" eskk.vim"{{{
if !exists('g:eskk#disable') || !g:eskk#disable
  let g:eskk#directory  =  "~/.vim/.eskk"
  "let g:eskk#dictionary  =  { 'path': "~/.vim/dict/skk.dict",  'sorted': 0,  'encoding': 'utf-8',  }
  let g:eskk#large_dictionary  =  { 'path': "~/SKK-JISYO.L",  'sorted': 1,  'encoding': 'euc-jp',  }
  let g:eskk#enable_completion = 1
  let g:eskk#start_completion_length = 2
  let g:eskk_map_normal_keys = 1
  let g:eskk#use_cursor_color = 1
  let g:eskk#show_annotation = 1
  let g:eskk#keep_state = 0
endif
"}}}
" }}}
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
  nnoremap <buffer> <C-j> :Unite gtags/def gtags/ref -auto-preview -no-split<CR>
endfunction "}}}

" scala  "{{{
autocmd MyAutoCmd FileType scala call s:scala_my_settings()
function! s:scala_my_settings()
  setlocal ts=4
  setlocal sw=4
  setlocal noexpandtab
  compiler scalac
  nmap <buffer> [make] :<C-u>make %<CR>
endfunction "}}}

" python  "{{{
autocmd MyAutoCmd FileType python call s:python_my_settings()
function! s:python_my_settings()
  setlocal ts=4
  setlocal sw=4
  setlocal expandtab
endfunction "}}}

" help "{{{
autocmd MyAutoCmd FileType help call s:help_my_settings()
function! s:help_my_settings()
  nnoremap <buffer> <TAB> <C-w>w
  nnoremap <silent> <buffer> qq :bd<CR>
endfunction "}}}
" vimshell {{{
autocmd MyAutoCmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()
  imap <silent><buffer> <C-j> <Plug>(vimshell_exit):q<CR>
endfunction"}}}

"}}}
" ======== Post Process Setting {{{
" source localized vimrc"{{{
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
"}}}
" }}}


"=============================================================-
" vundle
"=============================================================-

set nocompatible
filetype off
" Vundle
set rtp+=~/.vim/vundle.git/
call vundle#rc()
"Bundle 'vim-ruby/vim-ruby.git'
Bundle 'm2ym/rsense.git'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tsaleh/vim-align.git'
Bundle 'tsaleh/vim-matchit.git'
Bundle 'thinca/vim-quickrun.git'
Bundle 'thinca/vim-ref.git'
Bundle 'thinca/vim-qfreplace.git'
Bundle 'fuenor/qfixhowm'
Bundle 'othree/eregex.vim.git'
Bundle 'motemen/git-vim.git'
Bundle 'Shougo/unite.vim.git'
Bundle 'Shougo/unite-build.git'
Bundle 'Shougo/neocomplcache.git'
Bundle 'Shougo/vimshell.git'
Bundle 'Shougo/vimfiler.git'
Bundle 'Shougo/vimproc.git'
Bundle 'Shougo/vim-vcs.git'
Bundle 'h1mesuke/unite-outline.git'
Bundle 'sgur/unite-qf.git'
Bundle 'kmnk/vim-unite-svn.git'
"Bundle 'ujihisa/unite-locate.git'
Bundle 'kana/vim-smartchr.git'
Bundle 'kana/vim-altercmd'
Bundle 'Sixeight/unite-grep.git'
Bundle 'tsukkee/unite-tag.git'
Bundle 'ujihisa/unite-colorscheme.git'
Bundle 'vim-scripts/gtags.vim.git'
Bundle 'vim-scripts/DrawIt.git'
Bundle 'vim-scripts/wombat256.vim.git'
filetype plugin indent on

"=============================================================-
" basic setting
"=============================================================-

" Map Leader {{{
let mapleader= ','
let g:mapleader = ','
let g:maplocalleader = 'm'
"}}}

let s:has_win = has('win32') || has('win64')

" Exchange path separator.
if s:has_win
    set shellslash
endif

" abosorb difference between windows and Linux
let dotvim = $HOME . "/.vim"

set title
set noruler

" split window direction {{{
set splitbelow
set splitright
" }}}

syntax on
set hidden

" set cursolline only focused window
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

" indent setting{{{
set autoindent
set cindent
" tab setting
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set smartindent
"}}}

" cursor hilight setting{{{
set cursorline
set nocursorcolumn
" }}}

set browsedir=buffer
set backspace=indent,eol,start
set clipboard=unnamed
set showcmd
"set number

" list chars
set list
set listchars=eol:$,tab:>\ ,extends:<

" scroll
"set scroll=5
set scrolloff=0

set showmatch
set laststatus=2

"search settings {{{
set smartcase
set ignorecase
set wrapscan
set incsearch
set hlsearch
"}}}

"Japanese input etc settings {{{
set noimdisable
set noimcmdline
set iminsert=1
set imsearch=1
"}}}

" always show tab
set showtabline=2
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


" swp file dir
set directory-=.
if v:version >= 703
  set undofile
  let &undodir=&directory
endif

" Backupfile dir
set nobackup
set nowritebackup
" Round tab width
set shiftround
" tags
if has('path_extra')
"  set tags+=.;
"  set tags+=tags;
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
"set completeopt=menuone,preview
set completeopt=menuone
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=20
" use ack for grep
set grepprg=ack\ -a
" use help for K
set keywordprg=:help

set display=lastline
if exists('&ambiwidth')
  set ambiwidth=double
endif

autocmd FileType * set formatoptions-=ro
scriptencoding  utf-8
highlight Zenkaku cterm=underline ctermfg=Green guifg=Green
au BufRead,BufNew * match Zenkaku /ã/

"=============================================================-
" key mapping
"=============================================================-
" insert
inoremap <C-l> <ESC>

" normal
nnoremap <silent> <Leader><Leader> :bnext<CR>
nnoremap <Leader>a :Ref<SPACE>alc<SPACE>
nnoremap <SPACE> <C-^>
nnoremap ,t :tabnew<SPACE>
nnoremap Y y$
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap <expr> sw ':%s/\<' . expand('<cword>') .'\>/'

" bash like key-bind at cmdline
cnoremap <C-h> <BS>
cnoremap <C-l> <ESC>
cnoremap <C-b> <Left>
cnoremap <C-e> <END>
cnoremap <C-a> <HOME>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

vnoremap $ $h

" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>/
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

"-------------------------------------------------------
" color
"-------------------------------------------------------
set t_Co=256
set background=dark
colorscheme wombat256mod

hi CursorLine term=reverse cterm=none ctermbg=233
hi CursorColumn term=reverse cterm=none ctermbg=233
hi Pmenu ctermbg=darkgrey ctermfg=white
hi PmenuSel ctermbg=grey ctermfg=black
hi PmenuSbar ctermbg=0 ctermfg=white
hi StatusLine term=NONE cterm=NONE ctermfg=white ctermbg=darkred

let g:hi_insert = 'highlight StatusLine ctermfg=18 ctermbg=red cterm=none'
hi IncSearch term=NONE cterm=NONE ctermfg=white ctermbg=52

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
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

"==============================================================
" misc setting
"==============================================================
" FIXME: only project tab return project name
function! s:GetCDProjectName()
  if !exists('g:unite_source_bookmark_directory')
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

" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
call altercmd#load()
command! -complete=dir -nargs=? TabpageCD
      \ execute 'cd' fnameescape(<q-args>)
      \| let t:cwd  =  getcwd()
      \| let t:project  =  s:GetCDProjectName()

AlterCommand cd TabpageCD
command! -nargs=0 CD silent execute 'TabpageCD' unite#util#path2project_directory(expand('%:p'))

autocmd VimEnter,TabEnter *
      \ if !exists('t:cwd')
      \| let t:cwd = getcwd()
      \| endif
      \| if !exists('t:project')
      \| let t:project = s:GetCDProjectName()
      \| endif
      \| execute 'cd' fnameescape(t:cwd)
"}}}

"-------------------------------------------------------
" kill line from current to eol "{{{
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

"-------------------------------------------------------
" kill buffer, not close window {{{
" http://nanasi.jp/articles/vim/kwbd_vim.html
:com! Kwbd let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn 
nnoremap <C-k>  :Kwbd<CR>
"}}}

"-------------------------------------------------------
" The automatic recognition of the character code."{{{
"if !exists('did_encoding_settings') && has('iconv')
    "let s:enc_euc = 'euc-jp'
    "let s:enc_jis = 'iso-2022-jp'

    "" Does iconv support JIS X 0213?
    "if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        "let s:enc_euc = 'euc-jisx0213,euc-jp'
        "let s:enc_jis = 'iso-2022-jp-3'
    "endif
 
    "" Build encodings.
    "let &fileencodings = 'ucs-bom'
    "if &encoding !=# 'utf-8'
        "let &fileencodings = &fileencodings . ',' . 'ucs-2le'
        "let &fileencodings = &fileencodings . ',' . 'ucs-2'
    "endif
    "let &fileencodings = &fileencodings . ',' . s:enc_jis

    "if &encoding ==# 'utf-8'
        "let &fileencodings = &fileencodings . ',' . s:enc_euc
        "let &fileencodings = &fileencodings . ',' . 'cp932'
    "elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
        "let &encoding = s:enc_euc
        "let &fileencodings = &fileencodings . ',' . 'utf-8'
        "let &fileencodings = &fileencodings . ',' . 'cp932'
    "else  " cp932
        "let &fileencodings = &fileencodings . ',' . 'utf-8'
        "let &fileencodings = &fileencodings . ',' . s:enc_euc
        "                                      endif
    "let &fileencodings = &fileencodings . ',' . &encoding

    "unlet s:enc_euc
    "unlet s:enc_jis

    "let did_encoding_settings = 1
"endif
"}}}

"-------------------------------------------------------
" Default fileformat.
"-------------------------------------------------------
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
" A fullwidth character is displayed in vim properly.
set ambiwidth=double

"---------------------------------------------------------------------------
" Input Japanese:"{{{
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

"-------------------------------------------------------
" Set augroup.
"-------------------------------------------------------
augroup MyAutoCmd
    autocmd!
augroup END

if !has('gui_running') && !(has('win32') || has('win64'))
    autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
    autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC | 
                \if has('gui_running') | source $MYGVIMRC  
    autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif

"-------------------------------------------------------
" tab line setting
"-------------------------------------------------------
" status line format
function! Dirname()
  if exists("t:project") && ! empty(t:project)
    return t:project . "\ %f"
  else
    return "%f"
  end
  return 
endfunction

function! MyStatusLine()
  return "\%{fugitive#statusline()}". Dirname(). "\ %m%r%h%w\%=[FORMAT=%{&ff}]\[TYPE=%Y]\%{'[ENC='.(&fenc!=''?&fenc:&enc).']'}[%05l/%L:%04c]"
endfunction

set statusline=%!MyStatusLine()
"set statusline=%F%m%r%h%w\%=[FORMAT=%{&ff}]\[TYPE=%Y]\%{'[ENC='.(&fenc!=''?&fenc:&enc).']'}[%05l/%L:%04c]

function! MyTabLabel(n)
  let buflist  =  tabpagebuflist(a:n)
  let winnr  =  tabpagewinnr(a:n)
  "return project . bufname(buflist[winnr - 1]) 
  return bufname(buflist[winnr - 1]) 
endfunction

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
  if tabpagenr('$') > 1 
    let s .= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction
set tabline=%!MyTabLine()

"=============================================================
" Plugins
"=============================================================
"---------------------------------------------------------------------
" neocomplcache.vim {{{
"---------------------------------------------------------------------
" snippets directory
let g:NeoComplCache_SnippetsDir = '~/.vim/snippets'

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
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

let g:neocomplcache_vim_completefuncs = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimShellExecute' : 'vimshell#complete#vimshell_execute_complete#completefunc',
      \ 'VimShellTerminal' : 'vimshell#complete#vimshell_execute_complete#completefunc', 
      \ 'VimShellInteractive' : 'vimshell#complete#vimshell_execute_complete#completefunc',
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


" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-c> neocomplcache#complete_common_string()
nnoremap <Leader>es :NeoComplCacheEditSnippets<CR>

" expand snippets by TAB
imap  <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<TAB>"
smap  <TAB> <Plug>(neocomplcache_snippets_expand)

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

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


"---------------------------------------------------------------------
" unite.vim "{{{
"---------------------------------------------------------------------
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
nnoremap <silent> [unite]b :UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]c :UniteWithCurrentDir -buffer-name=files file<CR>
nnoremap <silent> [unite]t :Unite tab<CR>
nnoremap <silent> [unite]T :Unite tag<CR>
nnoremap <silent> [unite]y :Unite register<CR>
nnoremap <silent> [unite]a :UniteBookmarkAdd<CR>
nnoremap <silent> [unite]p :Unite bookmark -default-action=cd -no-start-insert<CR>
nnoremap <silent> [unite]j :Unite jump<CR>
" Explore home dir
nnoremap <silent> <expr> [unite]h ':UniteWithInput -buffer-name=files file -input='. $HOME .'/<CR>'
nnoremap <silent> <expr> <C-h> ':UniteWithInput -buffer-name=files file -input='. $HOME .'/<CR>'
nnoremap <silent> <Leader>l :Unite buffer_tab -no-start-insert<CR>
nnoremap <silent> [unite]l :Unite line<CR>
nnoremap <expr> [unite]g ':Unite grep:'. expand("%:h") . ':-r'
nnoremap <silent> [unite]* :UniteWithCursorWord line<CR>
nnoremap <silent> [unite]o :Unite -buffer-name=outline outline<CR>
nnoremap <silent> [unite]q :Unite qf -no-start-insert<CR>
nnoremap [unite]s<SPACE> :Unite svn/
nnoremap <silent> [unite]sd :Unite svn/diff<CR>
nnoremap <silent> [unite]sb :Unite svn/blame<CR>
nnoremap <silent> [unite]ss :Unite svn/status<CR>
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
  inoremap <silent><buffer> <C-o> <Esc>:call unite#mappings#do_action('tabopen')<CR>
  inoremap <silent><buffer> <C-v> <Esc>:call unite#mappings#do_action('vsplit')<CR>
  inoremap <silent><buffer> <C-s> <Esc>:call unite#mappings#do_action('split')<CR>
  inoremap <silent><buffer> <C-r> <Esc>:call unite#mappings#do_action('rec')<CR>
  inoremap <silent><buffer> <C-e> <Esc>:call unite#mappings#do_action('edit')<CR>
  imap <silent><buffer> <C-j> <Plug>(unite_exit)
  nmap <silent><buffer> <C-j> <Plug>(unite_exit)
  inoremap <silent><buffer> <SPACE> _
  inoremap <silent><buffer> _ <SPACE>

  call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)
  call unite#set_substitute_pattern('file', '/\ze[^*]', '/*', 10)

  call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
  call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
  call unite#set_substitute_pattern('file', '^\\', '~/*')

  call unite#set_substitute_pattern('file', '\*\*\+', '*', -1)

  call unite#set_substitute_pattern('file', '\\\@<! ', '\\ ', -20)
  call unite#set_substitute_pattern('file', '\\ \@!', '/', -30)
  call unite#custom_max_candidates('file_rec', 100)
endfunction "}}}
"}}}

"---------------------------------------------------------------------
" smartchr.vim"{{{
"---------------------------------------------------------------------
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

  autocmd FileType ruby
        \ inoremap <buffer> <expr> = smartchr#loop('=', ' = ', ' == ', ' === ')
        \| inoremap <buffer> <expr> ~ smartchr#loop('~', ' =~ ', ' !~ ')
        \| inoremap <buffer> <expr> > smartchr#loop(' > ', ' => ', ' >> ', '>')

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

"---------------------------------------------------------------------
" q: Quickfix "{{{
"---------------------------------------------------------------------

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

"---------------------------------------------------------------------
" vimfiler.vim"{{{
"---------------------------------------------------------------------
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
"let g:vimshell_cd_command = 'TabpageCD'

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

"---------------------------------------------------------------------
" vimshell.vim"{{{
"---------------------------------------------------------------------
nnoremap <Leader>x :VimShellTab<CR>
let g:vimshell_user_prompt = 'getcwd()'
autocmd MyAutoCmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()"{{{
  imap <silent><buffer> <C-j> <Plug>(vimshell_exit)
endfunction"}}}

"}}}

"---------------------------------------------------------------------
" gtags.vim"{{{
"---------------------------------------------------------------------
nnoremap <C-j> :GtagsCursor<CR>
"}}}

"=============================================================
" for language
"=============================================================
" Java
autocmd MyAutoCmd FileType java call s:java_my_settings()
function! s:java_my_settings()"{{{
  let g:java_highlight_functions = 'style'
  let g:java_highlight_all = 1
  let g:java_allow_cpp_keywords = 1
endfunction"}}}

" ruby
autocmd MyAutoCmd FileType ruby call s:ruby_my_settings()
function! s:ruby_my_settings()"{{{
  compiler ruby
  nmap [make] :<C-u>make -c %<CR>
  set ts=2
  set sw=2
  set expandtab
endfunction"}}}

" c
autocmd MyAutoCmd FileType c call s:clang_my_settings()
function! s:clang_my_settings()"{{{
  setlocal ts=8
  setlocal sw=4
  setlocal noexpandtab
endfunction"}}}

autocmd MyAutoCmd FileType help call s:help_my_settings()
function! s:help_my_settings()"{{{
  nnoremap <buffer> <TAB> <C-w>w
  nnoremap <silent> <buffer> <SPACE> :bd<CR>
  nnoremap <buffer> j 5j
  nnoremap <buffer> k 5k
endfunction"}}}


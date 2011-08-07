"=============================================================-
" basic setting
"=============================================================-
let $VIMHOME=$HOME"/.vim"

colorscheme zellner

set nocompatible
filetype off
" Vundle
set rtp+=~/.vim/vundle.git/
call vundle#rc()
Bundle 'vim-ruby/vim-ruby.git'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'tpope/vim-surround'
Bundle 'thinca/vim-quickrun.git'
Bundle 'tsaleh/vim-align.git'
Bundle 'tsaleh/vim-matchit.git'
Bundle 'thinca/vim-ref.git'
Bundle 'shemerey/vim-project.git'
Bundle 'othree/eregex.vim.git'
Bundle 'motemen/git-vim.git'
Bundle 'Shougo/unite.vim.git'
Bundle 'Shougo/neocomplcache.git'
Bundle 'Shougo/vimshell.git'
Bundle 'h1mesuke/unite-outline.git'
Bundle 'sgur/unite-qf.git'
Bundle 'kmnk/vim-unite-svn.git'
Bundle 'ujihisa/unite-locate.git'
filetype plugin indent on

" Map <Leader> ','
let mapleader= ','
let g:mapleader = ','
let g:maplocalleader = ','

" Exchange path separator.
if has('win32') || has('win64') 
    set shellslash
endif

let s:has_win = has('win32') || has('win64')
" abosorb difference between windows and Linux
if s:has_win
    let $DOTVIM = $VIM."/vimfiles"
else
    let $DOTVIM = $HOME."/.vim"
endif

set title
set ruler
set tabstop=2
set shiftwidth=2
set splitbelow
set splitright
set expandtab
set autoindent
set hidden
set cursorline
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

set nocursorcolumn
syntax on
set browsedir=buffer
set backspace=indent,eol,start
set clipboard=unnamed
set showcmd
set incsearch
set hlsearch
set number
set list
set laststatus=2
set listchars=eol:$,tab:>\ ,extends:<
set showmatch
set smartcase
set smartindent
set smarttab
set whichwrap=b,s,h,l,<,>,[,]
set statusline=%F%m%r%h%w\%=[FORMAT=%{&ff}]\[TYPE=%Y]\%{'[ENC='.(&fenc!=''?&fenc:&enc).']'}[%p%%]
" completion option
set nowildmenu
set wildmode=list:full
" virtual edit always
set virtualedit=all
" swp file dir
set directory=$VIMHOME
" backupfile dir
set backup
set backupdir=$TMPDIR
" round tab width
set shiftround
" show full info about tag
set showfulltag
" No Beep
set visualbell
set vb t_vb=
" Spell check language
set spelllang=en_us
" Completion setting.
set completeopt=menuone
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=20

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
inoremap <C-l> <ESC>
nnoremap <silent> mm :bnext<CR>
nnoremap <C-h> :bNext<CR>
nnoremap <C-l> :bnext<CR>
nnoremap <Leader>a :Ref<SPACE>alc<SPACE>
nnoremap ,t :tabnew<SPACE>
nnoremap Y y$
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap <expr> sw ':%s/\<' . expand('<cword>') .'\>/'

" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>/
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

"-------------------------------------------------------
" color
"-------------------------------------------------------
set t_Co=256
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

"-------------------------------------------------------
" for language
"-------------------------------------------------------
" Java
let g:java_highlight_functions = 'style'
let g:java_highlight_all = 1
let g:java_allow_cpp_keywords = 1

"=============================================================-
" misc setting
"=============================================================-
"-------------------------------------------------------
" kill line from current to eol
"-------------------------------------------------------
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

"-------------------------------------------------------
" The automatic recognition of the character code."{{{
"-------------------------------------------------------
if !exists('did_encoding_settings') && has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'

    " Does iconv support JIS X 0213?
    if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213,euc-jp'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
 
    " Build encodings.
    let &fileencodings = 'ucs-bom'
    if &encoding !=# 'utf-8'
        let &fileencodings = &fileencodings . ',' . 'ucs-2le'
        let &fileencodings = &fileencodings . ',' . 'ucs-2'
    endif
    let &fileencodings = &fileencodings . ',' . s:enc_jis

    if &encoding ==# 'utf-8'
        let &fileencodings = &fileencodings . ',' . s:enc_euc
        let &fileencodings = &fileencodings . ',' . 'cp932'
    elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
        let &encoding = s:enc_euc
        let &fileencodings = &fileencodings . ',' . 'utf-8'
        let &fileencodings = &fileencodings . ',' . 'cp932'
    else  " cp932
        let &fileencodings = &fileencodings . ',' . 'utf-8'
        let &fileencodings = &fileencodings . ',' . s:enc_euc
    endif
    let &fileencodings = &fileencodings . ',' . &encoding

    unlet s:enc_euc
    unlet s:enc_jis

    let did_encoding_settings = 1
endif
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
    highlight CursorIM ctermfg=NONE ctermbg=Purple
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

"=============================================================-
" Plugins
"=============================================================-

" -------------------- 
" neocomplcache
" -------------------- 
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
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete


"---------------------------------------------------------------------
" unite
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
nnoremap <silent> [unite]f :Unite -buffer-name=file file_mru<CR>
nnoremap <silent> [unite]r :Unite file_rec<CR>
nnoremap <silent> [unite]c :UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]t :Unite tab<CR>
nnoremap <silent> [unite]y :Unite register<CR>
nnoremap <silent> [unite]a :UniteBookmarkAdd<CR>
nnoremap <silent> [unite]b :Unite bookmark<CR>
nnoremap <silent> <Leader>l :Unite buffer_tab<CR>
nnoremap <silent> [unite]g :Unite line<CR>
nnoremap <silent> [unite]* :UniteWithCursorWord line<CR>
nnoremap <silent> [unite]l :Unite locate<CR>
nnoremap <silent> [unite]o :Unite outline<CR>
nnoremap <silent> [unite]q :Unite qf<CR>
nnoremap [unite]s<SPACE> :Unite svn/
nnoremap <silent> [unite]sd :Unite svn/diff<CR>
nnoremap <silent> [unite]sb :Unite svn/blame<CR>
nnoremap <silent> [unite]ss :Unite svn/status<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  nnoremap <silent><buffer> <C-o> :call unite#mappings#do_action('tabopen')<CR>
  nnoremap <silent><buffer> <C-v> :call unite#mappings#do_action('vsplit')<CR>
  inoremap <silent><buffer> <C-o> <Esc>:call unite#mappings#do_action('tabopen')<CR>

  call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)
  call unite#set_substitute_pattern('file', '/\ze[^*]', '/*', 10)

  call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
  call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
  call unite#set_substitute_pattern('file', '^\\', '~/*')

  call unite#set_substitute_pattern('file', '\*\*\+', '*', -1)

  call unite#set_substitute_pattern('file', '\\\@<! ', '\\ ', -20)
  call unite#set_substitute_pattern('file', '\\ \@!', '/', -30)
  let g:unite_enable_ignore_case = 1
  let g:unite_enable_smart_case = 1
endfunction"}}}


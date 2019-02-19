
" ======== Initialize Section {{{
augroup MyAutoCmd
  autocmd!
augroup END

let $DOTVIM = expand('~/.vim')
let $VIMBUNDLE = $DOTVIM . '/bundle'
let $NEOBUNDLE = $VIMBUNDLE . '/neobundle.vim'
"}}}
" ======== NeoBundle Setting {{{
" Variable Initialization {{{
if !isdirectory($NEOBUNDLE)
  " should 'git submodule init/update' at .vim/ before launch vim
  echoerr $NEOBUNDLE ' is not directory'
endif

let s:load_error_bundles = []
function! s:config_bundle(bundle_name, config_func)
  let l:bundle = neobundle#get(a:bundle_name)
  if empty(l:bundle)
    echoerr a:bundle_name . " is not bundled"
  else
    call a:config_func(l:bundle)
  endif
endfunction

if has('vim_starting') && isdirectory($NEOBUNDLE)
  if &compatible
    set nocompatible
  endif
  filetype off
  set rtp+=$NEOBUNDLE
endif
" }}}

" NeoBundle loading stage {{{
try
  call neobundle#begin($VIMBUNDLE)
  let g:neobundle#types#git#default_protocol = 'https'

  NeoBundleFetch 'Shougo/neobundle.vim.git'

  " Unite
  NeoBundle 'Shougo/unite.vim.git'
  NeoBundleLazy 'Shougo/unite-build.git', {'autoload' : {
        \ 'unite_sources' : 'build',
        \  }}
  NeoBundle 'Shougo/tabpagebuffer.vim'
  NeoBundle 'Shougo/unite-outline.git',{'autoload' : {
        \ 'unite_sources' : 'outline',
        \  }}
  NeoBundleLazy 'kmnk/vim-unite-svn.git', {'autoload' : {
        \ 'unite_sources' : ['svn/status', 'svn/info', 'svn/blame', 'svn/diff'],
        \  }}
  NeoBundleLazy 'tsukkee/unite-help' ,{'autoload' : {
        \ 'unite_sources' : 'help',
        \  }}
  NeoBundleLazy 'osyo-manga/unite-quickfix', {'autoload' : {
        \ 'unite_sources' : 'quickfix',
        \  }}
  NeoBundleLazy 'ujihisa/unite-colorscheme.git', {'autoload' : {
        \ 'unite_sources' : 'colorscheme',
        \  }}
  NeoBundle 'hewes/unite-gtags.git', {'autoload' : {
        \ 'depends' : ['Shougo/unite.vim.git'],
        \ 'unite_sources' : ['gtags/context', 'gtags/ref', 'gtags/def', 'gtags/completion', 'gtags/grep','gtags/path'],
        \  }}

  " Input support
  if has('lua')
    NeoBundleLazy "Shougo/neocomplete.vim", { 'autoload' : {
          \ 'insert' : 1,
          \ }}
  else
    NeoBundleLazy "Shougo/neocomplcache", { 'autoload' : {
          \ 'insert' : 1,
          \ }}
  endif
  NeoBundle 'ujihisa/neco-look.git'

  NeoBundleLazy 'Shougo/neosnippet.git',  {'autoload' : {
        \ 'insert' : 1,
        \ }}

  NeoBundleLazy 'Shougo/neosnippet-snippets.git',  {'autoload' : {
        \ 'insert' : 1,
        \ 'depends' : ['Shougo/neosnippet.git'],
        \ }}

  NeoBundle 'kana/vim-smartchr.git'
  NeoBundle 'kana/vim-smartinput'
  NeoBundle 'tyru/eskk.vim'
  NeoBundleLazy 'vim-scripts/DrawIt.git', { 'autoload' : {
        \ 'commands' : ['DrawIt'],
        \ }}

  " Handle buffer word
  NeoBundle 'scrooloose/nerdcommenter.git'
  NeoBundle 'tpope/vim-surround'
  NeoBundle 'h1mesuke/vim-alignta.git'

  " Quickrun
  NeoBundle 'osyo-manga/vim-watchdogs', {'depends' : ['thica/vim-quickrun']}
  NeoBundleLazy 'thinca/vim-quickrun', { 'autoload' : {
        \ 'mappings' : ['nxo', '<Plug>(quickrun)'],
        \ 'commands' : ['QuickRun', 'UniteQuickRunConfig'],
        \ }}

  " VCS
  NeoBundle 'tpope/vim-fugitive'
  NeoBundle 'Shougo/vim-vcs.git'
  NeoBundle 'vim-scripts/vcscommand.vim.git'

  " Appearance
  NeoBundle 'vim-airline/vim-airline.git'
  NeoBundle 'vim-airline/vim-airline-themes.git'
  NeoBundle 'osyo-manga/vim-anzu'
  NeoBundle 'hewes/context-highlight.vim.git'
  NeoBundle 'tomtom/quickfixsigns_vim.git'

  " Programming Language
  NeoBundle 'rosstimson/scala-vim-support.git'
  NeoBundle 'derekwyatt/vim-sbt.git'

  " Filetype
  NeoBundle 'timcharper/textile.vim'

  " Util
  NeoBundle 'Shougo/vimshell.git'
  NeoBundleLazy 'Shougo/vimfiler.git', { 'autoload' : {
        \ 'commands' : ['VimFiler', 'VimFilerSimple'],
        \ }}
  NeoBundle 'sjl/gundo.vim.git', { 'autoload' : {
        \ 'commands' : ['GundoShow', 'GundoHide', 'GundoToggle', 'GundoRenderGraph'],
        \ }}
  NeoBundleLazy 'thinca/vim-ref.git', { 'autoload' : {
        \ 'commands' : ['Ref'],
        \ 'mappings' : ['<Plug>(ref-keyword)'],
        \ }}

  " Etc
  NeoBundleLazy 'vim-jp/vital.vim.git', { 'autoload' : {
        \ 'commands' : ['Vitalize'],
        \ }}
  NeoBundle 'Shougo/vimproc.git' , { 'build' : {
        \ 'mingw' : 'make -f make_mingw.mak',
        \ 'mac'   : 'make -f make_mac.mak',
        \ 'unix'  : 'make -f make_unix.mak',
        \ }, }
  NeoBundle 'kana/vim-altercmd'
  NeoBundle 'kana/vim-operator-user'
  NeoBundle 'kana/vim-operator-replace'

  NeoBundle 'tpope/vim-repeat.git'
  NeoBundle 'fuenor/qfixgrep'
  NeoBundle 'kien/ctrlp.vim.git'
  " }}}

  " ======== Plugin Settings {{{
  " ----- neocomplcache.vim {{{
  function! s:configure_neocomplcache(bundle)
    " keymapping {{{
    " neocomplcache prefix
    nmap <Leader>c [neocomplcache]
    nnoremap [neocomplcache]e :<C-u>NeoComplCacheEditSnippets<CR>
    inoremap <expr><C-l> neocomplcache#complete_common_string()
    " Plugin key-mappings.
    inoremap <expr><C-g> neocomplcache#undo_completion()
    inoremap <expr><C-c> neocomplcache#complete_common_string()
    " }}}

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
    let g:neocomplcache_min_syntax_length = 1
    let g:neocomplcache_disable_caching_file_path_pattern = '*.log'
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplcache_auto_completion_start_length = 1
    let g:neocomplcache_plugin_completion_length_list = {
          \   'snippets_complete' : 1,
          \   'buffer_complete' : 2,
          \   'syntax_complete' : 2,
          \   'tags_complete' : 2,
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

    let g:neocomplcache_text_mode_filetypes = {
          \ 'txt' :1,
          \ 'md' :1,
          \ }

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif
  endfunction
  " }}}

  " ------- neocomplete {{{
  function! s:configure_neocomplete(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:neocomplete#enable_at_startup = 1
      let g:neocomplete#auto_completion_start_length = 2
      let g:neocomplete#min_keyword_length = 2

      let g:neocomplete#enable_auto_select = 0

      " TODO: after patch for completeopt noinsert option
      let g:neocomplete#enable_complete_select = 0
      "let g:neocomplete#enable_complete_select = 1
      let g:neocomplete#enable_refresh_always = 0
      let g:neocomplete#enable_smart_case = 1
      let g:neocomplete#enable_fuzzy_completion = 1
      let g:neocomplete#enable_auto_delimiter = 1

      let g:neocomplete#enable_auto_close_preview = 1

      " sources setting

      " omni source
      if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
      end
      let g:neocomplete#sources#omni#input_patterns = {}
      let g:neocomplete#sources#omni#functions = {}

      " vim source
      if !exists('g:neocomplete#sources#vim#complete_functions')
        let g:neocomplete#sources#vim#complete_functions = {}
      endif
      let g:neocomplete#sources#vim#complete_functions.Ref = 'ref#complete'
      let g:neocomplete#sources#vim#complete_functions.Unite = 'untie#complete_source'

      if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
      endif

      if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
      end
      let g:neocomplete#keyword_patterns['default'] = '\h\w*'

      let g:neocomplete#sources#syntax#min_keyword_length = 2

      " keymappings
      let g:neocomplete#text_mode_filetypes = {
            \ 'txt' :1,
            \ 'md' :1,
            \ }

      " Define dictionary.
      let g:neocomplete#sources#dictionary#min_keyword_length = 2
      let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'ruby' : $HOME.'/.vim/dict/ruby.dict',
            \ 'java' : $HOME.'/.vim/dict/java.dict',
            \ }
    endfunction

    function! a:bundle.hooks.on_post_source(bundle)
      call neocomplete#custom#source('include', 'disabled_filetypes', {'_' : 1})
      call neocomplete#custom#source('tag', 'disabled_filetypes', {'vim' : 1})
      call neocomplete#custom#source('_', 'converters', ['converter_delimiter', 'converter_abbr'])
      inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() . "\<Space>"  : "\<Space>"
      inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
    endfunction
  endfunction
  if has('lua')
    call s:config_bundle("neocomplete.vim", function("s:configure_neocomplete"))
  else
    call s:config_bundle("neocomplcache", function("s:configure_neocomplcache"))
  endif
  " }}}

  " neosnippet prefix {{{
  function! s:configure_neosnippet(bundle)
    function! a:bundle.hooks.on_source(bundle)
      " expand snippets by TAB
      imap <silent> <expr> <Tab> <SID>tab_wrapper()
      function! s:tab_wrapper()
        if neosnippet#expandable_or_jumpable()
          return "\<Plug>(neosnippet_expand_or_jump)"
        endif
        return "\<Plug>(skip_position)""
      endfunction
      let g:neosnippet#snippets_directory = $HOME. '/.vim/snippets'
    endfunction
  endfunction
  call s:config_bundle("neosnippet", function('s:configure_neosnippet'))
  " }}}

  " unite-gtags {{{
  function! s:configure_unite_gtags(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:unite_source_gtags_project_config = {
            \ '_': { 'treelize': 0, 'absolute_path': 0},
            \ }
    endfunction
  endfunction
  call s:config_bundle("unite-gtags", function('s:configure_unite_gtags'))
" }}}

  " unite.vim "{{{
  function! s:configure_unite(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:unite_enable_ignore_case = 1
      let g:unite_enable_smart_case = 1
      let g:unite_enable_start_insert = 1
      let g:unite_enable_split_vertically  =  0
      let g:unite_source_file_mru_limit  =  300
      let g:unite_source_file_rec_min_cache_files = 300
      let g:unite_source_file_rec_max_depth = 10
      let g:unite_kind_openable_cd_command = 'TabpageCD'
      let g:unite_kind_openable_lcd_command = 'TabpageCD'
      let g:unite_winheight = 20
      let g:unite_source_history_yank_enable = 1
      let g:unite_source_bookmark_directory = $HOME . "/.unite/bookmark"

      autocmd MyAutoCmd FileType unite call s:unite_my_settings()
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
        inoremap <silent><buffer> <C-j> <ESC>:quit<CR>
        nmap <silent><buffer> <C-j> <Plug>(unite_all_exit)
        inoremap <silent><buffer> <SPACE> _
        inoremap <silent><buffer> _ <SPACE>
      endfunction "}}}
    endfunction

    function! a:bundle.hooks.on_post_source(bundle)
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
      nnoremap <silent> [unite]r :UniteResume<CR>
      nnoremap [unite]R :Unite ref/
      nnoremap <silent> [unite]b :UniteWithBufferDir file file/new<CR>
      nnoremap <silent> [unite]c :Unite -buffer-name=files file file/new<CR>
      nnoremap <silent> [unite]n :Unite -buffer-name=files gtags/path file/new<CR>
      nnoremap <silent> [unite]t :Unite tab<CR>
      nnoremap <silent> [unite]y :Unite register<CR>
      nnoremap <silent> [unite]a :UniteBookmarkAdd<CR>
      nnoremap <silent> [unite]p :Unite bookmark -default-action=cd -no-start-insert<CR>
      " Explore home dir
      nnoremap <silent> <expr> [unite]h ':UniteWithInput -buffer-name=files file file/new -input='. substitute($HOME, '\' ,'/', 'g') .'/<CR>'
      nnoremap <silent> [unite]H :<C-u>Unite history/yank<CR>
      nnoremap <silent> [unite]j :Unite buffer_tab -no-start-insert<CR>
      nnoremap <silent> [unite]l :Unite -auto-preview line<CR>
      nnoremap <expr> [unite]g ':Unite grep:'. expand("%:h") . ':-r'
      nnoremap <silent> [unite]* :UniteWithCursorWord line<CR>
      nnoremap <silent> [unite]o :Unite -buffer-name=outline outline<CR>
      nnoremap <silent> [unite]q :Unite quickfix -no-start-insert<CR>
      nnoremap [unite]s<SPACE> :Unite svn/
      nnoremap <silent> [unite]sd :Unite svn/diff<CR>
      nnoremap <silent> [unite]sb :Unite svn/blame<CR>
      nnoremap <silent> [unite]ss :Unite svn/status<CR>
      nnoremap <C-j> :Unite gtags/context<CR>
      function! UniteCurrentProjectShortcut(key)
        if exists("t:local_unite") && has_key(t:local_unite, a:key)
          execute t:local_unite[a:key]
        else
          echo "ERROR: t:local_unite is not defined or not has key: ". a:key
        endif
      endfunction
      let s:local_unite_source = {
            \ "name"        : "local",
            \ "description" : 'Unite commands defined at t:local_unite',
            \ }
      function! s:local_unite_source.gather_candidates(args, context)
        let l:candidates = []
        if exists("t:local_unite")
          for key in sort(keys(t:local_unite))
            let l:candidate = {
                  \ 'word'            : key . ': ' . t:local_unite[key],
                  \ 'kind'            : 'command',
                  \ 'action__command' : t:local_unite[key] . ' ',
                  \ 'source__command' : ':'. t:local_unite[key],
                  \ }
            call add(l:candidates, l:candidate)
          endfor
        else
          call unite#print_message("[unite-local] Warning: t:local_unite is not defined")
        endif
        return l:candidates
      endfunction

      call unite#define_source(s:local_unite_source)
      for key_number in [1, 2, 3, 4, 5, 6, 7, 8, 9]
        execute printf('nnoremap <silent> [unite]%d :<C-u> call UniteCurrentProjectShortcut(%d)<CR>', key_number, key_number)
      endfor

      nnoremap [unite]<SPACE> :Unite local<CR>
    endfunction
  endfunction
  call s:config_bundle("unite.vim", function('s:configure_unite'))
  "}}}

  " quickfixsigns_vim"{{{
  function! s:configure_quickfixsigns_vim(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:quickfixsigns_sign_may_use_double=0
    endfunction
  endfunction
  call s:config_bundle("quickfixsigns_vim", function('s:configure_quickfixsigns_vim'))
  " }}}

  " smartchr.vim"{{{
  function! s:configure_smartchr(bundle)
    function! a:bundle.hooks.on_post_source(bundle)
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
    endfunction
  endfunction
  call s:config_bundle("vim-smartchr", function("s:configure_smartchr"))
  "}}}

  " vimfiler.vim"{{{
  function! s:configure_vimfiler(bundle)
    function! a:bundle.hooks.on_source(bundle)
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

    endfunction

    function! a:bundle.hooks.on_post_source(bundle)
      "nnoremap <silent> <Leader>v :<C-u>VimFiler `=<SID>GetBufferDirectory()`<CR>
      nnoremap <silent> <Leader>f :<C-u>VimFiler<CR>
      nnoremap <silent> <Leader>s :<C-u>VimFilerSimple<CR>
      autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
    endfunction

    function! s:vimfiler_my_settings() "{{{
      " Overwrite settings.
      " Set local mappings.
      nmap <buffer> <C-p> <Plug>(vimfiler_open_previous_file)
      nmap <buffer> <C-n> <Plug>(vimfiler_open_next_file)
    endfunction "}}}
  endfunction
  call s:config_bundle("vimfiler", function("s:configure_vimfiler"))
  "}}}

  " vimshell.vim"{{{
  function! s:configure_vimshell(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:vimshell_user_prompt = 'getcwd()'
    endfunction

    function! a:bundle.hooks.on_post_source(bundle)
      nnoremap <Leader>x :VimShellTab<CR>
    endfunction
  endfunction
  call s:config_bundle('vimshell', function('s:configure_vimshell'))
  "}}}

  " eskk.vim"{{{
  function! s:configure_eskk(bundle)
    function! a:bundle.hooks.on_source(bundle)
      if !exists('g:eskk#disable') || !g:eskk#disable
        let g:eskk#directory  =  "~/.vim/.eskk"
        "let g:eskk#dictionary  =  { 'path': "~/.vim/dict/skk.dict",  'sorted': 0,  'encoding': 'utf-8',  }
        " SKK-JISYO from http://openlab.jp/skk/dic/SKK-JISYO.L.gz
        let g:eskk#large_dictionary  =  { 'path': "~/SKK-JISYO.L",  'sorted': 1,  'encoding': 'euc-jp',  }
        let g:eskk#enable_completion = 1
        let g:eskk#start_completion_length = 2
        let g:eskk_map_normal_keys = 1
        let g:eskk#use_cursor_color = 1
        let g:eskk#show_annotation = 1
        let g:eskk#keep_state = 0
      endif
      " overwrite other plugin setting (e.g.) smartinput)
    endfunction

    function! a:bundle.hooks.on_post_source(bundle)
      imap <C-j> <Plug>(eskk:toggle)
    endfunction
  endfunction
  call s:config_bundle("eskk.vim", function("s:configure_eskk"))
  "}}}

  " vim-quickrun "{{{
  function! s:configure_quickrun(bundle)
    let g:quickrun_config = {}
    function! a:bundle.hooks.on_source(bundle)
      let g:quickrun_config._ = {'runner': "vimproc"}
      let g:quickrun_config["watchdogs_checker/_"]  = {
            \ "runner" : "vimproc",
            \ "outputter" : "quickfix",
            \ "hook/quickfix_status_enable/enable_exit" : 1,
            \ "hook/quickfixsigns_enable/enable_exit" : 1,
            \ "hook/qfixgrep_enable/enable_exit" : 1,
            \ 'runmode' : "async:remote:vimproc",
            \ "outputter/quickfix/open_cmd" : "",
            \ }
      " TODO: should consider class_path, and library on scala application
      let g:quickrun_config['watchdogs_checker/nop'] = {
            \ "command" : "echo",
            \ "exec"    : "%c nop",
            \}
      "let g:quickrun_config['scala/watchdogs_checker'] = {"type" : "watchdogs_checker/nop"}
      let g:watchdogs_check_BufWritePost_enables = {
            \ "scala" : 0
            \ }
      let s:pyflakes = executable('pyflakes3') ? 'pyflakes3' :
            \          executable('python3') ? 'python3' :
            \          executable('pyflakes') ? 'pyflakes' :
            \          'python'
      let s:cmdopt = executable('pyflakes3') ? '' :
            \          executable('python3') ? '-m pyflakes' :
            \          executable('pyflakes') ? '' :
            \          '-m pyflakes'
      let g:quickrun_config["watchdogs_checker/pyflakes3"] = {
            \ "command" : s:pyflakes,
            \ "cmdopt" : s:cmdopt,
            \ "exec"    : "%c %o %s:p",
            \ "errorformat" : '%f:%l:%m',
            \ }
      unlet s:pyflakes
      unlet s:cmdopt
    endfunction
    function! a:bundle.hooks.on_post_source(bundle)
    endfunction
  endfunction
  call s:config_bundle('vim-quickrun', function('s:configure_quickrun'))
  " }}}

  " quickfixsigns_vim {{{
  let g:quickfixsigns_classes = ['qfl', 'loc', 'vcsdiff', 'breakpoints']
  " }}}

  " vim-watchdogs "{{{
  function! s:configure_watchdogs(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:watchdogs_check_BufWritePost_enable = 1
    endfunction

    function! a:bundle.hooks.on_post_source(bundle)
      call watchdogs#setup(g:quickrun_config)
    endfunction
  endfunction
  call s:config_bundle('vim-watchdogs', function('s:configure_watchdogs'))
  " }}}

  " operator-replace {{{
  function! s:configure_operator_replace(bundle)
    function! a:bundle.hooks.on_post_source(bundle)
      map <C-/>r <Plug>(operator-replace)
    endfunction
  endfunction
  call s:config_bundle("vim-operator-replace", function("s:configure_operator_replace"))
  " }}}

  " vim-anzu {{{
  function! s:configure_vim_anzu(bundle)
    function! a:bundle.hooks.on_source(bundle)
      nmap n <Plug>(anzu-n)
      nmap N <Plug>(anzu-N)
      nmap * <Plug>(anzu-star)
      nmap # <Plug>(anzu-sharp)
    endfunction
  endfunction
  call s:config_bundle("vim-anzu",  function("s:configure_vim_anzu"))
  " }}}

  " vim-bufferline{{{
  let g:bufferline_echo = 0
  let g:bufferline_show_bufnr = 0
  let g:bufferline_active_buffer_left = '['
  let g:bufferline_active_buffer_right = ']'
  let g:bufferline_modified = '+'
  " }}}

  " vim-surround{{{
  function! s:configure_vim_surround(bundle)
    function! a:bundle.hooks.on_source(bundle)
      let g:surround_no_mappings = 1
      nmap ds  <Plug>Dsurround
      nmap cs  <Plug>Csurround
      nmap ys  <Plug>Ysurround
      nmap yS  <Plug>YSurround
      nmap yss <Plug>Yssurround
      nmap ySs <Plug>YSsurround
      nmap ySS <Plug>YSsurround
      xmap s   <Plug>VSurround
      xmap gs  <Plug>VgSurround
    endfunction
  endfunction
  call s:config_bundle("vim-surround", function('s:configure_vim_surround'))
  "}}}

  " Drawit{{{
  function! s:configure_drawit(bundle)
    function! a:bundle.hooks.on_post_source(bundle)
      nnoremap  <Leader>di :DrawIt<CR>
      map  <Leader>ds <Plug>DrawItStop
    endfunction
  endfunction
  call s:config_bundle("DrawIt", function('s:configure_drawit'))
  " }}}

  " vim-ref {{{
  function! s:configure_vimref(bundle)
    function! a:bundle.hooks.on_post_source(bundle)
      nnoremap <Leader>a :Ref<SPACE>alc<SPACE>
      silent! nmap <silent> <unique> K <Plug>(ref-keyword)
      silent! vmap <silent> <unique> K <Plug>(ref-keyword)
    endfunction
  endfunction
  call s:config_bundle('vim-ref', function('s:configure_vimref'))
  " }}}
  " }}}
  call neobundle#end()
catch /117/
  echo "load NeoBundle failed"
endtry
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
set iminsert=1 imsearch=1

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

" Enable omni completion.
autocmd MyAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd MyAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd MyAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd MyAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd MyAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" ------ The encoding setting {{{
if s:has_win
  " if windows use cp932
  if &encoding !=? 'cp932'
    let &termencoding = &encoding
    set encoding=cp932
  endif
else
  " else use utf-8.
  if &encoding !=? 'utf-8'
    let &termencoding = &encoding
    set encoding=utf-8
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

" :TabpageCD - wrapper of :cd to keep cwd for each tabpage  "{{{
function! s:configure_altercmd(bundle)
  call altercmd#load()
  AlterCommand cd TabpageCD
  command! -nargs=0 CD silent execute 'TabpageCD' unite#util#path2project_directory(expand('%:p'))
endfunction
call s:config_bundle("vim-altercmd", function('s:configure_altercmd'))

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
  nnoremap <buffer> <C-j> :Unite gtags/def gtags/ref<CR>
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
" unlet unnecessary script variable
if !empty(s:load_error_bundles)
  echomsg "Configure Error: ". string(s:load_error_bundles)
endif
unlet s:has_win
unlet s:load_error_bundles
" }}}


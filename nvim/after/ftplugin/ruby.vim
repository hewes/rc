" enable rsense
"if exists('g:loaded_rsense') && filereadable(expand('~/.vim/bundle/rsense/bin/rsense'))
"let g:rsenseUseOmniFunc = 1
"let g:rsenseHome = expand('~/.vim/bundle/rsense')
"let g:neocomplcache_omni_functions['ruby'] = 'RSenseCompleteFunction'
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"endif
"
function! s:syntax_id()
  return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction
command! SyntaxId echo s:syntax_id()

function! s:sysid_match(sys_ids)
  if index(a:sys_ids, s:syntax_id()) >= 0
    return 1
  else
    return 0
  endif
endfunction

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
command! ValidateRubyIndent call <SID>validate_ruby_indent()


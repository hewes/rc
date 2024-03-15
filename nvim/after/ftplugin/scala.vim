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


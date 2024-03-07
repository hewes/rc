"
" theme is one of autoload/airline/themes
let g:airline_theme = 'wombat'
if has('multi_byte')
  " TODO should only enable on environment where the font is patched
  let g:airline_powerline_fonts = 0
endif
" fileformat[fileencoding]
let g:airline_section_y = "%{strlen(&ff)?&ff:''}" . "[%{strlen(&fenc)?&fenc:&enc}]"
let g:airline_section_z = "L:%l/%L C:%4c"


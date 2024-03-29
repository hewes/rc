" customize wambat256

set background=dark

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

let colors_name = "capybara"

" General colors
hi Normal		ctermfg=252		ctermbg=none		cterm=none		guifg=#e3e0d7	guibg=#000000	gui=none
hi Cursor		ctermfg=234		ctermbg=228		cterm=none		guifg=#242424	guibg=#eae788	gui=none
hi Visual		ctermfg=251		ctermbg=239		cterm=none		guifg=#c3c6ca	guibg=#554d4b	gui=none
hi VisualNOS	ctermfg=251		ctermbg=236		cterm=none		guifg=#c3c6ca	guibg=#303030	gui=none
hi Search		ctermfg=177		ctermbg=241		cterm=none		guifg=#d787ff	guibg=#636066	gui=none
hi Folded		ctermfg=103		ctermbg=237		cterm=none		guifg=#a0a8b0	guibg=#3a4046	gui=none
hi Title		ctermfg=230						cterm=bold		guifg=#ffffd7					gui=bold
hi StatusLine term=NONE cterm=NONE ctermfg=white ctermbg=darkred guifg=white	guibg=darkred	gui=none
hi VertSplit	ctermfg=238		ctermbg=238		cterm=none		guifg=#444444	guibg=#444444	gui=none
hi StatusLineNC	ctermfg=241		ctermbg=238		cterm=none		guifg=#857b6f	guibg=#444444	gui=none
hi LineNr		ctermfg=241		ctermbg=232		cterm=none		guifg=#857b6f	guibg=#080808	gui=none
hi SpecialKey	ctermfg=241		ctermbg=233		cterm=none		guifg=#626262	guibg=#2b2b2b	gui=none
hi WarningMsg	ctermfg=203										guifg=#ff5f55
hi ErrorMsg		ctermfg=196		ctermbg=236		cterm=bold		guifg=#ff2026	guibg=#3a3a3a	gui=bold

" Vim >= 7.0 specific colors
if version >= 700
hi CursorLine term=none ctermfg=none ctermbg=239 guibg=#32322f
hi CursorColumn term=none ctermfg=none ctermbg=233 guibg=#32322f
hi MatchParen term=NONE cterm=NONE ctermfg=NONE ctermbg=52 guifg=NONE guibg=red
hi Pmenu		ctermfg=230		ctermbg=238						guifg=#ffffd7	guibg=#444444
hi PmenuSel		ctermfg=232		ctermbg=192						guifg=#080808	guibg=#cae982
endif

" Diff highlighting
hi DiffAdd						ctermbg=17										guibg=#2a0d6a
hi DiffDelete	ctermfg=234		ctermbg=60		cterm=none		guifg=#242424	guibg=#3e3969	gui=none
hi DiffText						ctermbg=53		cterm=none						guibg=#73186e	gui=none
hi DiffChange					ctermbg=237										guibg=#382a37

"hi CursorIM
"hi Directory
hi IncSearch term=NONE cterm=NONE ctermfg=white ctermbg=52
"hi Menu
"hi ModeMsg
"hi MoreMsg
"hi PmenuSbar
"hi PmenuThumb
"hi Question
"hi Scrollbar
hi SignColumn ctermfg=14 ctermbg=234 guifg=Cyan guibg=Black
"hi SpellCap
"hi SpellLocal
"hi SpellRare
"hi TabLine
"hi TabLineFill
hi TabLineSel ctermfg=232		ctermbg=192						guifg=#080808	guibg=#cae982
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu


" Syntax highlighting
hi Keyword		ctermfg=111		cterm=none		guifg=#88b8f6	gui=none
hi Statement	ctermfg=111		cterm=none		guifg=#88b8f6	gui=none
hi Constant		ctermfg=209		cterm=none		guifg=#e5786d	gui=none
hi Number		ctermfg=173		cterm=none		guifg=#e5786d	gui=none
hi PreProc		ctermfg=99		cterm=none		guifg=#875fff	gui=none
hi Function		ctermfg=180		cterm=none		guifg=#cae982	gui=none
hi Identifier	ctermfg=192		cterm=none		guifg=#cae982	gui=none
hi Type			ctermfg=47		cterm=none		guifg=#00ff5f	gui=none
hi Special		ctermfg=229		cterm=none		guifg=#eadead	gui=none
hi String		ctermfg=113		cterm=none		guifg=#95e454	gui=none
hi Comment		ctermfg=246		cterm=none		guifg=#9c998e	gui=none
hi Todo			ctermfg=102		ctermbg=none	cterm=none		guifg=#857b6f	gui=none

hi UnderLineWarning	cterm=undercurl

" Links
hi! link FoldColumn		Folded
hi! link CursorColumn	CursorLine
hi! link NonText		LineNr

" vim:set ts=4 sw=4 noet:


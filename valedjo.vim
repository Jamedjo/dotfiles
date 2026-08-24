" ~ Valedjo ~
" jamedjo's variety on the Nightbar ground: pink keywords, chartreuse types,
" cream strings, lilac symbols, aqua identifiers, mist comments, rust line
" numbers, a tan statusline. Reads the valedjo terminal palette;
" gui values are the same hexes for truecolor.

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "valedjo"

" General highlighting
highlight Normal ctermfg=7 ctermbg=NONE cterm=NONE guifg=#d9e6fa guibg=#0c1c36 gui=NONE
highlight Comment ctermfg=4 ctermbg=NONE cterm=NONE guifg=#849bc4 guibg=NONE gui=NONE
highlight Statement ctermfg=9 ctermbg=NONE cterm=NONE guifg=#ff2177 guibg=NONE gui=NONE
highlight Define ctermfg=9 ctermbg=NONE cterm=NONE guifg=#ff2177 guibg=NONE gui=NONE
highlight Macro ctermfg=9 ctermbg=NONE cterm=NONE guifg=#ff2177 guibg=NONE gui=NONE
highlight PreProc ctermfg=9 ctermbg=NONE cterm=NONE guifg=#ff2177 guibg=NONE gui=NONE
highlight Function ctermfg=10 ctermbg=NONE cterm=NONE guifg=#c9d45f guibg=NONE gui=NONE
highlight Type ctermfg=10 ctermbg=NONE cterm=NONE guifg=#c9d45f guibg=NONE gui=NONE
highlight Identifier ctermfg=14 ctermbg=NONE cterm=NONE guifg=#98dddb guibg=NONE gui=NONE
highlight String ctermfg=11 ctermbg=NONE cterm=NONE guifg=#fecc77 guibg=NONE gui=NONE
highlight Constant ctermfg=13 ctermbg=NONE cterm=NONE guifg=#b291dd guibg=NONE gui=NONE
highlight Special ctermfg=12 ctermbg=NONE cterm=NONE guifg=#7fc9ea guibg=NONE gui=NONE
highlight Todo ctermfg=0 ctermbg=3 cterm=NONE guifg=#0c1c36 guibg=#ffb14d gui=NONE
highlight Error ctermfg=15 ctermbg=1 cterm=NONE guifg=#f2f7ff guibg=#e0563f gui=NONE

" Ruby highlighting
highlight rubySymbol ctermfg=13 ctermbg=NONE cterm=NONE guifg=#b291dd guibg=NONE gui=NONE
highlight rubyInclude ctermfg=9 ctermbg=NONE cterm=NONE guifg=#ff2177 guibg=NONE gui=NONE
highlight rubyStringDelimiter ctermfg=11 ctermbg=NONE cterm=NONE guifg=#fecc77 guibg=NONE gui=NONE
highlight rubyBlockParameterList ctermfg=14

" Window highlighting
highlight Title ctermfg=15 cterm=bold guifg=#dfb890 gui=bold
highlight TabLine ctermfg=4 ctermbg=0 cterm=NONE guifg=#849bc4 guibg=#0e1f3a gui=NONE
highlight TabLineSel ctermfg=15 ctermbg=NONE cterm=bold guifg=#dfb890 gui=bold
highlight TabLineFill ctermbg=0 cterm=NONE guibg=#0e1f3a gui=NONE
highlight StatusLine ctermfg=15 ctermbg=0 cterm=NONE guifg=#dfb890 guibg=#182f52 gui=NONE
highlight StatusLineNC ctermfg=4 ctermbg=0 cterm=NONE guifg=#849bc4 guibg=#0e1f3a gui=NONE
highlight VertSplit ctermfg=8 ctermbg=NONE cterm=NONE guifg=#b25c3c guibg=NONE gui=NONE
highlight WildMenu ctermfg=15 ctermbg=9 cterm=NONE guifg=#ffffff guibg=#ff2177 gui=NONE

" Editor highlighting
highlight LineNr ctermfg=8 ctermbg=NONE cterm=NONE guifg=#b25c3c guibg=NONE gui=NONE
highlight CursorLineNr ctermfg=3 ctermbg=NONE cterm=NONE guifg=#ffb14d guibg=NONE gui=NONE
highlight CursorLine ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#0e1f3a gui=NONE
highlight ColorColumn ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#0e1f3a gui=NONE
highlight SignColumn ctermfg=8 ctermbg=NONE cterm=NONE guifg=#b25c3c guibg=NONE gui=NONE
highlight Visual ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#182f52 gui=NONE
highlight Search ctermfg=0 ctermbg=3 cterm=NONE guifg=#0c1c36 guibg=#ffb14d gui=NONE
highlight IncSearch ctermfg=0 ctermbg=11 cterm=NONE guifg=#0c1c36 guibg=#fecc77 gui=NONE
highlight MatchParen ctermfg=11 ctermbg=8 cterm=NONE guifg=#fecc77 guibg=#b25c3c gui=NONE
highlight Pmenu ctermfg=7 ctermbg=0 cterm=NONE guifg=#d9e6fa guibg=#12294a gui=NONE
highlight PmenuSel ctermfg=15 ctermbg=9 cterm=NONE guifg=#ffffff guibg=#ff2177 gui=NONE
highlight PmenuSbar ctermbg=0 guibg=#182f52
highlight PmenuThumb ctermbg=8 guibg=#b25c3c
highlight Folded ctermfg=4 ctermbg=0 cterm=NONE guifg=#849bc4 guibg=#0e1f3a gui=NONE
highlight NonText ctermfg=8 ctermbg=NONE cterm=NONE guifg=#7a4530 guibg=NONE gui=NONE
highlight SpecialKey ctermfg=8 ctermbg=NONE cterm=NONE guifg=#7a4530 guibg=NONE gui=NONE
highlight Directory ctermfg=12 ctermbg=NONE cterm=NONE guifg=#7fc9ea guibg=NONE gui=NONE
highlight ErrorMsg ctermfg=15 ctermbg=1 cterm=NONE guifg=#f2f7ff guibg=#e0563f gui=NONE
highlight WarningMsg ctermfg=3 ctermbg=NONE cterm=NONE guifg=#ffb14d guibg=NONE gui=NONE
highlight MoreMsg ctermfg=12 ctermbg=NONE cterm=NONE guifg=#7fc9ea guibg=NONE gui=NONE
highlight Question ctermfg=12 ctermbg=NONE cterm=NONE guifg=#7fc9ea guibg=NONE gui=NONE

" Diff highlighting — the two colours that have to mean what they say
highlight DiffAdd    cterm=NONE ctermfg=0 ctermbg=2 guifg=#0c1c36 guibg=#7fae4f
highlight DiffDelete cterm=NONE ctermfg=0 ctermbg=1 guifg=#0c1c36 guibg=#e0563f
highlight DiffChange cterm=NONE ctermfg=NONE ctermbg=0 guifg=NONE guibg=#182f52
highlight DiffText   cterm=NONE ctermfg=0 ctermbg=11 guifg=#0c1c36 guibg=#fecc77

" Spelling
highlight SpellBad ctermfg=1 ctermbg=NONE cterm=underline guifg=#e0563f gui=undercurl
highlight SpellCap ctermfg=12 ctermbg=NONE cterm=underline guifg=#7fc9ea gui=undercurl

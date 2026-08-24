" ~ Vale Nightbar ~
" The desk theme in the editor: blues carry structure, amber carries data,
" the wallpaper's teal and stage magenta take the corners. Reads the 16-slot
" vale-nightbar terminal palette; gui values are the same hexes for truecolor.

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "vale-nightbar"

" General highlighting
highlight Normal ctermfg=7 ctermbg=NONE cterm=NONE guifg=#dce9fb guibg=#0c1c36 gui=NONE
highlight Comment ctermfg=60 ctermbg=NONE cterm=NONE guifg=#5f769a guibg=NONE gui=NONE
highlight Statement ctermfg=4 ctermbg=NONE cterm=NONE guifg=#2f7ff0 guibg=NONE gui=NONE
highlight Define ctermfg=4 ctermbg=NONE cterm=NONE guifg=#2f7ff0 guibg=NONE gui=NONE
highlight Macro ctermfg=4 ctermbg=NONE cterm=NONE guifg=#2f7ff0 guibg=NONE gui=NONE
highlight PreProc ctermfg=9 ctermbg=NONE cterm=NONE guifg=#ff7a6e guibg=NONE gui=NONE
highlight Function ctermfg=12 ctermbg=NONE cterm=NONE guifg=#5aa6ff guibg=NONE gui=NONE
highlight Type ctermfg=6 ctermbg=NONE cterm=NONE guifg=#3fd2c4 guibg=NONE gui=NONE
highlight Identifier ctermfg=110 ctermbg=NONE cterm=NONE guifg=#8fb4e4 guibg=NONE gui=NONE
highlight String ctermfg=3 ctermbg=NONE cterm=NONE guifg=#ffb14d guibg=NONE gui=NONE
highlight Constant ctermfg=5 ctermbg=NONE cterm=NONE guifg=#c778dd guibg=NONE gui=NONE
highlight Special ctermfg=13 ctermbg=NONE cterm=NONE guifg=#e0a2f5 guibg=NONE gui=NONE
highlight Todo ctermfg=0 ctermbg=3 cterm=NONE guifg=#0c1c36 guibg=#ffb14d gui=NONE
highlight Error ctermfg=15 ctermbg=1 cterm=NONE guifg=#f2f7ff guibg=#ff4a4a gui=NONE

" Ruby highlighting
highlight rubySymbol ctermfg=5 ctermbg=NONE cterm=NONE guifg=#c778dd guibg=NONE gui=NONE
highlight rubyInclude ctermfg=4 ctermbg=NONE cterm=NONE guifg=#2f7ff0 guibg=NONE gui=NONE
highlight rubyBlockParameterList ctermfg=14

" Window highlighting
highlight Title ctermfg=15 cterm=bold guifg=#f2f7ff gui=bold
highlight TabLine ctermfg=8 ctermbg=0 cterm=NONE guifg=#7f96b8 guibg=#0e1f3a gui=NONE
highlight TabLineSel ctermfg=15 ctermbg=NONE cterm=bold guifg=#f2f7ff gui=bold
highlight TabLineFill ctermbg=0 cterm=NONE guibg=#0e1f3a gui=NONE
highlight StatusLine ctermfg=15 ctermbg=0 cterm=NONE guifg=#f2f7ff guibg=#182f52 gui=NONE
highlight StatusLineNC ctermfg=8 ctermbg=0 cterm=NONE guifg=#5f769a guibg=#0e1f3a gui=NONE
highlight VertSplit ctermfg=8 ctermbg=NONE cterm=NONE guifg=#3f5375 guibg=NONE gui=NONE
highlight WildMenu ctermfg=15 ctermbg=4 cterm=NONE guifg=#ffffff guibg=#2f7ff0 gui=NONE

" Editor highlighting
highlight LineNr ctermfg=8 ctermbg=NONE cterm=NONE guifg=#3f5375 guibg=NONE gui=NONE
highlight CursorLineNr ctermfg=12 ctermbg=NONE cterm=NONE guifg=#5aa6ff guibg=NONE gui=NONE
highlight CursorLine ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#0e1f3a gui=NONE
highlight ColorColumn ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#0e1f3a gui=NONE
highlight SignColumn ctermfg=8 ctermbg=NONE cterm=NONE guifg=#3f5375 guibg=NONE gui=NONE
highlight Visual ctermfg=NONE ctermbg=0 cterm=NONE guifg=NONE guibg=#182f52 gui=NONE
highlight Search ctermfg=0 ctermbg=3 cterm=NONE guifg=#0c1c36 guibg=#ffb14d gui=NONE
highlight IncSearch ctermfg=0 ctermbg=11 cterm=NONE guifg=#0c1c36 guibg=#ffc169 gui=NONE
highlight MatchParen ctermfg=11 ctermbg=8 cterm=NONE guifg=#ffc169 guibg=#3f5375 gui=NONE
highlight Pmenu ctermfg=7 ctermbg=0 cterm=NONE guifg=#dce9fb guibg=#12294a gui=NONE
highlight PmenuSel ctermfg=15 ctermbg=4 cterm=NONE guifg=#ffffff guibg=#2f7ff0 gui=NONE
highlight PmenuSbar ctermbg=0 guibg=#182f52
highlight PmenuThumb ctermbg=8 guibg=#3f5375
highlight Folded ctermfg=60 ctermbg=0 cterm=NONE guifg=#5f769a guibg=#0e1f3a gui=NONE
highlight NonText ctermfg=8 ctermbg=NONE cterm=NONE guifg=#3f5375 guibg=NONE gui=NONE
highlight SpecialKey ctermfg=8 ctermbg=NONE cterm=NONE guifg=#3f5375 guibg=NONE gui=NONE
highlight Directory ctermfg=12 ctermbg=NONE cterm=NONE guifg=#5aa6ff guibg=NONE gui=NONE
highlight ErrorMsg ctermfg=15 ctermbg=1 cterm=NONE guifg=#f2f7ff guibg=#ff4a4a gui=NONE
highlight WarningMsg ctermfg=3 ctermbg=NONE cterm=NONE guifg=#ffb14d guibg=NONE gui=NONE
highlight MoreMsg ctermfg=12 ctermbg=NONE cterm=NONE guifg=#5aa6ff guibg=NONE gui=NONE
highlight Question ctermfg=12 ctermbg=NONE cterm=NONE guifg=#5aa6ff guibg=NONE gui=NONE

" Diff highlighting — the two colours that have to mean what they say
highlight DiffAdd    cterm=NONE ctermfg=0 ctermbg=2 guifg=#0c1c36 guibg=#43c457
highlight DiffDelete cterm=NONE ctermfg=0 ctermbg=1 guifg=#0c1c36 guibg=#ff4a4a
highlight DiffChange cterm=NONE ctermfg=NONE ctermbg=0 guifg=NONE guibg=#182f52
highlight DiffText   cterm=NONE ctermfg=0 ctermbg=11 guifg=#0c1c36 guibg=#ffc169

" Spelling
highlight SpellBad ctermfg=1 ctermbg=NONE cterm=underline guifg=#ff4a4a gui=undercurl
highlight SpellCap ctermfg=12 ctermbg=NONE cterm=underline guifg=#5aa6ff gui=undercurl

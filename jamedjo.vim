" ~ Jamedjo ~
" Comments lifted from Stereokai / Monokai-Refined

"set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "jamedjo"

" General highlighting
"highlight Normal ctermfg=231 ctermbg=234 cterm=NONE guifg=#f8f8f2 guibg=#212121 gui=NONE
highlight Normal ctermfg=231 ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=#212121 gui=NONE
highlight Define ctermfg=9 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
highlight Statement ctermfg=9 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
highlight Macro ctermfg=9 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
highlight Type ctermfg=10 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
highlight Function ctermfg=10 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
highlight Comment ctermfg=4 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
"highlight Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
highlight Identifier ctermfg=1 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
highlight String ctermfg=11 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
highlight Special ctermfg=1 ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=NONE gui=NONE
highlight PreProc ctermfg=7 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE

" Ruby highlighting
highlight rubySymbol ctermfg=14 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
highlight rubyInclude ctermfg=9 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
highlight rubyBLockParameterList ctermfg=1

" Window highlighting
highlight Title ctermfg=7
highlight TabLine ctermfg=5 ctermbg=0
highlight TabLineFill ctermbg=0 cterm=NONE

" Diff highlighting
highlight DiffAdd    cterm=NONE ctermfg=0 ctermbg=10
highlight DiffDelete cterm=NONE ctermfg=0 ctermbg=9
highlight DiffChange cterm=NONE ctermfg=0 ctermbg=6
highlight DiffText   cterm=NONE ctermfg=0 ctermbg=11


call plug#begin()
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'scrooloose/nerdcommenter'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  "Plug 'ctrlpvim/ctrlp.vim'
  Plug '~/.fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'vim-ruby/vim-ruby'
  "Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'ludovicchabant/vim-gutentags'
call plug#end()

set mouse=a
"set relativenumber
set modelines=0
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

let g:airline_theme='zenburn'
let g:NERDDefaultAlign = 'left'
map <C-p> :FZF<CR>

map <C-k><C-b> :NERDTreeToggle<CR>
map <C-_> <Plug>NERDCommenterToggle
map <C-g> :Tags<CR>
nnoremap <C-k><C-k> :let @+=expand("%")<CR>

highlight DiffAdd    cterm=NONE ctermfg=0 ctermbg=10
highlight DiffDelete cterm=NONE ctermfg=0 ctermbg=9
highlight DiffChange cterm=NONE ctermfg=0 ctermbg=6
highlight DiffText   cterm=NONE ctermfg=0 ctermbg=11

"Close Tree sidebar if it is the last thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

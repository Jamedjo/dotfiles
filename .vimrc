call plug#begin()
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'scrooloose/nerdcommenter'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'flazz/vim-colorschemes'
  Plug 'Jamedjo/setcolors.vim' "Plug '~/Scripts/setcolors.vim'
  Plug '~/.fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'mhinz/vim-grepper'
  Plug 'romainl/vim-qf'
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'mhinz/vim-startify'
call plug#end()

filetype plugin on

set mouse=a
"set relativenumber
set modelines=0
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

set background=dark
colo jamedjo "stereokai dracula thor PaperColor
let g:airline_theme='base16'

let g:NERDDefaultAlign = 'left'
map <C-p> :FZF<CR>

nnoremap <C-S-F> :Grepper -cword -side<cr>
map <Esc>f <A-f>
nnoremap <A-f> :Grepper -cword<cr>
let g:qf_mapping_ack_style = 1
nmap <Home> <Plug>(qf_qf_previous)
nmap <End> <Plug>(qf_qf_next)

map <C-k><C-b> :NERDTreeToggle<CR>
map <C-_> <Plug>NERDCommenterToggle
map <C-g> :Tags<CR>
nnoremap <C-k><C-k> :let @+=expand("%")<CR>

"Close Tree sidebar if it is the last thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

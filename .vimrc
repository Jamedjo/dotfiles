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
  Plug 'dense-analysis/ale'
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'kchmck/vim-coffee-script'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'mhinz/vim-startify'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'airblade/vim-gitgutter'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'kana/vim-fakeclip'
call plug#end()

filetype plugin indent on
packadd! matchit

set history=10000
set mouse=a
"set relativenumber
set modelines=0
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

set background=dark
colo jamedjo "stereokai dracula thor PaperColor
let g:airline_theme='base16'

"Remap recording to Q, to avoid accidents
nnoremap Q q
nnoremap q <Nop>

let g:NERDDefaultAlign = 'left'
map <C-p> :FZF<CR>
map <leader>b :Buffers<CR>
map <leader>g :GFiles?<CR>
map <leader>l :Lines<CR>
map <leader>m :Marks<CR>
map <leader>w :Windows<CR>
map <leader>t :Windows<CR>
map <leader>c :Commits<CR>
map <leader>h :History<CR>

nnoremap <C-S-F> :Grepper -cword -side<cr>
map <Esc>f <A-f>
nnoremap <A-f> :Grepper -cword<cr>
let g:qf_mapping_ack_style = 1
nmap <Home> <Plug>(qf_qf_previous)
nmap <End> <Plug>(qf_qf_next)

map <C-k><C-b> :NERDTreeToggle<CR>
map <C-_> <Plug>NERDCommenterToggle
map <C-g> :Tags<CR>
"nnoremap <C-k><C-k> :let @+=expand("%")<CR>
nnoremap <C-k><C-k> :!wl-copy %<CR><CR>

let g:multi_cursor_select_all_word_key = '<leader><C-N>'
let g:ale_set_highlights = 0
set omnifunc=ale#completion#OmniFunc

let $FZF_DEFAULT_COMMAND = 'rg --files'

let g:gutentags_ctags_exclude = [ 'build', 'dist', 'node_modules', 'bower_components', 'cache', 'bundle', 'vendor', '*.min.*', 'package.json', '*-lock.json', '*.lock', '*bundle*.js', '*build*.js' ]
"let g:gutentags_file_list_command = { 'markers': { '.git': 'git ls-files', '.hg': 'hg files' }  }

" Wayland clipboard with wl-copy/wl-paste
let g:fakeclip_provide_clipboard_key_mappings = !empty($WAYLAND_DISPLAY)

"Close Tree sidebar if it is the last thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

au BufRead,BufNewFile *.vue set filetype=html

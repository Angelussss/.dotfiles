call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'scrooloose/nerdtree', {'on':'NERDTreeToggle'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'ellisonleao/gruvbox.nvim'
call plug#end()

:colorscheme gruvbox
set relativenumber
set nu rnu
set colorcolumn=80
set clipboard+=unnamedplus
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

let mapleader = " "

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>n  <cmd>NERDTreeToggle<cr>

nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h

tnoremap <esc><esc> <C-\><C-n>

nnoremap <silent> <leader>tl :rightbelow vnew <bar> terminal <cr>
nnoremap <silent> <leader>th :leftabove vnew <bar> terminal <cr>
nnoremap <silent> <leader>tj :belowright split <bar> terminal <cr>
nnoremap <silent> <leader>tk :aboveleft split <bar> terminal <cr>

nnoremap <silent> <leader>sl :rightbelow vnew <cr>
nnoremap <silent> <leader>sh :leftabove vnew <cr>
nnoremap <silent> <leader>sj :belowright split <cr>
nnoremap <silent> <leader>sk :aboveleft split <cr>

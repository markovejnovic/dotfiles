set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'sickill/vim-monokai'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'preservim/nerdtree'
Plugin 'justinmk/vim-sneak'
Plugin 'airblade/vim-gitgutter'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
"Plugin 'markovejnovic/vim-dssl2'
"Plugin 'tmhedberg/matchit'
"Plugin 'raingo/vim-matlab'
"Plugin 'Yggdroot/indentLine'
"Plugin 'wlangstroth/vim-racket'
"Plugin 'tpope/vim-scriptease'
"Plugin 'lervag/vimtex'
"Plugin 'mkotha/conflict3'

call vundle#end()            " required
filetype plugin indent on    " required

set t_Co=256
set termguicolors

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

syntax enable
colorscheme molokai

let g:airline_theme='molokai'
let g:airline#extensions#tabline#enabled = 1

" QOL
set mouse=a
set clipboard+=unnamedplus

" Default Tabs and cc
set cc=80
set tabstop=4 shiftwidth=4 expandtab

" Nerdtree Config
map ,nn :NERDTreeToggle<CR>
"
" Numbering
set number relativenumber

" COC

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

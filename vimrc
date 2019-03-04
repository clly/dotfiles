set nocompatible
filetype off
filetype plugin indent off    " required

set number
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set title

syntax on
filetype on
filetype plugin indent on    " required

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType eyaml setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2

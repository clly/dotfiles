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

" However, in Git commit messages, let’s make it 72 characters
autocmd FileType gitcommit set textwidth=72
" Colour the 81st (or 73rd) column so that we don’t type over our limit
autocmd FileType gitcommit set colorcolumn=+1
" In Git commit messages, also colour the 51st column (for titles)
autocmd FileType gitcommit set colorcolumn+=51

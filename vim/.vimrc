set visualbell
syntax on
set number
set linebreak
set ruler
set showmatch
set hlsearch
set smartcase
set ignorecase
set autoindent
set smartindent
set smarttab
set t_Co=16
set tw=81

highlight LineNR ctermfg=black

filetype plugin indent on

call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
call plug#end()

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
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:¦\ 

highlight SpecialKey ctermfg=black
highlight LineNR ctermfg=black

filetype plugin indent on

call plug#begin('~/.vim/plugged')

Plug 'https://github.com/mxw/vim-jsx.git'

call plug#end()

au FileType tex autocmd BufWritePost * BuildTexPdf

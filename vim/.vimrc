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

highlight LineNR ctermfg=black

filetype plugin indent on

au FileType tex autocmd BufWritePost * BuildTexPdf


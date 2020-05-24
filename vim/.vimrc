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
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set list
set listchars=tab:¦\ 

highlight SpecialKey ctermfg=black
highlight LineNR ctermfg=black

filetype plugin indent on

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'easymotion/vim-easymotion'
Plug 'ap/vim-css-color'
Plug 'itchyny/vim-cursorword'

call plug#end()

hi! CocWarningSign ctermfg=White guifg=#ff922b

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

filetype plugin indent on
syntax enable 
set autoindent " use indent from current line when making new line
set backspace=indent,eol,start " when at beginning of line, pressing backspace joins with prev line
set smarttab
set laststatus=2 "always show statusbar
set autoread "auto reload file when unchanged in vim and changed outside vim
set history=2000

call plug#begin()
Plug 'morhetz/gruvbox' "colorscheme
Plug 'mhinz/vim-startify' "fancy start screen
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
call plug#end()

let g:vim_markdown_folding_disabled = 1

let g:airline_powerline_fonts = 1

set background=dark
colorscheme gruvbox


filetype plugin indent on
syntax enable 
set autoindent  " use indent from current line when making new line
set backspace=indent,eol,start  " when at beginning of line, pressing backspace joins with prev line
set whichwrap+=<,>,[,]  " moves to next line when pressing right at end of line
set smarttab
set laststatus=2  " always show statusbar
set autoread  " auto reload file when unchanged in vim and changed outside vim
set history=2000
set scrolloff=1  " scrolling shows one line extra
set hlsearch  " highlight search results

call plug#begin()
Plug 'morhetz/gruvbox' " colorscheme
Plug 'mhinz/vim-startify' " fancy start screen
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular'  " needed for vim-markdown
Plug 'plasticboy/vim-markdown'
Plug 'lygaret/autohighlight.vim'  " auto-highlight same words under cursor
call plug#end()

let g:vim_markdown_folding_disabled = 1

let g:airline_powerline_fonts = 1

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
set updatetime=500  " 500ms to update screen (e.g. gutter) instead of default 4000ms

set background=dark
colorscheme gruvbox

" do not colorize background
highlight Normal ctermbg=none
highlight NonText ctermbg=none

highlight CursorAutoHighlight ctermbg=black

set encoding=utf-8
scriptencoding utf-8

filetype plugin indent on
syntax enable
set autoindent  " use indent from current line when making new line
set backspace=indent,eol,start  " when at beginning of line, pressing backspace joins with prev line
set whichwrap+=<,>,[,]  " moves to next line when pressing right at end of line
set smarttab
set laststatus=2  " always show statusbar
set autoread  " auto reload file when unchanged in vim and changed outside vim
set history=2000
set scrolloff=2  " scrolling shows one line extra
set hlsearch  " highlight search results

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" tab to switch to beg/end of bracket
nnoremap <tab> %
vnoremap <tab> %

call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'gabrielelana/vim-markdown'
Plug 'scrooloose/nerdtree'
call plug#end()

let g:netrw_liststyle=3
map <C-_> :NERDTreeToggle<CR>

let g:markdown_enable_spell_checking = 0
let g:markdown_enable_input_abbreviations = 0

let g:airline_powerline_fonts = 1
let g:airline_section_z = '%l|%c'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
set updatetime=500  " 500ms to update screen (e.g. gutter) instead of default 4000ms

set background=dark
colorscheme gruvbox

" show invisible chars
set list
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«
highlight SpecialKey ctermfg=grey
highlight NonText ctermfg=grey

" do not colorize background
highlight Normal ctermbg=none
highlight NonText ctermbg=none


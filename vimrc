
" vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'tpope/vim-sensible.git'
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-scriptease.git'
Plugin 'Raimondi/delimitMate'
Plugin 'gabesoft/vim-ags'
Plugin 'FelikZ/ctrlp-py-matcher'
" color schemes
Plugin 'morhetz/gruvbox'
Plugin 'sickill/vim-monokai'
Plugin 'ajh17/Spacegray.vim'
Plugin 'kristijanhusak/vim-hybrid-material'
call vundle#end()
filetype plugin indent on

" gui options
:set guioptions-=m
:set guioptions-=T
:set guioptions-=r
:set guioptions-=L

if executable('ag')
  let g:ctrlp_user_command = 'ag %s --hidden --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

colorscheme hybrid_reverse
let g:enable_bold_font = 1
let mapleader=" "
set background=dark
set history=10000
highlight Normal ctermbg=none
highlight NonText ctermbg=none


" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'hybrid'

" gitgutter
" let g:gitgutter_sign_column_always = 1
set updatetime=500

" ctrlp
let g:ctrlp_by_filename = 1
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }


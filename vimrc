
" vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'w0ng/vim-hybrid'
Plugin 'tpope/vim-scriptease.git'
Plugin 'tpope/vim-sensible.git'
call vundle#end()
filetype plugin indent on


:colorscheme hybrid
let mapleader=" "

" indentLine
let gindentLine_char = '┆'

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" gitgutter
let g:gitgutter_sign_column_always = 1



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
Plugin 'Raimondi/delimitMate'
Plugin 'gabesoft/vim-ags'
call vundle#end()
filetype plugin indent on

if executable('ag')
  let g:ctrlp_user_command = 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

:colorscheme hybrid
let mapleader=" "
set background=dark
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" indentLine
let gindentLine_char = '┆'

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'hybrid'

" gitgutter
let g:gitgutter_sign_column_always = 1
set updatetime=500

" ctrlp
let g:ctrlp_by_filename = 1
let g:ctrlp_show_hidden = 1

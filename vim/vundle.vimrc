set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim " git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'klen/python-mode'
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Plugin 'bling/vim-airline'
Plugin 'Shougo/neocomplcache'
Plugin 'flazz/vim-colorschemes'
Plugin 'kien/ctrlp.vim'
Bundle 'Yggdroot/indentLine'
"Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plugin 'plasticboy/vim-markdown'
"Plugin 'jtratner/vim-flavored-markdown'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'octol/vim-cpp-enhanced-highlight'
call vundle#end()
filetype plugin indent on

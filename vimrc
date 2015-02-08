source ~/.vim/vundle.vimrc
source ~/.vim/powerline.vimrc
source ~/.vim/neocomplcache.vimrc
source ~/.vim/youcompleteme.vimrc
source ~/.vim/nerdtree.vimrc
source ~/.vim/indentline.vimrc

:colorscheme smyck

" disable GUI-menubar
set guioptions-=T
set guioptions-=m

set t_Co=256

set guitablabel=%t

" enable (safe) loading of .vimrc from working directory
set exrc
set secure

" set background=dark
syntax enable
set showmode
set encoding=utf8
set ffs=unix,dos,mac
set wildmenu

" Turn backup off
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Always show the status line
set laststatus=2

" Sets how many lines of history VIM has to remember
set history=2000

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif



" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction



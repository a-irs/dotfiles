set encoding=utf-8
scriptencoding utf-8

filetype plugin on
syntax on
set backspace=indent,eol,start  " when at beginning of line, pressing backspace joins with prev line
set whichwrap+=<,>,[,]  " moves to next line when pressing right at end of line
set linebreak  " wrap lines at words
set smarttab
set laststatus=0  " never show statusbar
set autoread  " auto reload file when unchanged in vim and changed outside vim
set history=2000  " command history
set scrolloff=1  " scrolling shows one line extra
set hlsearch  " highlight search results
set incsearch  " search during input
set fillchars+=vert:│  " prettier split separator

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set updatetime=150

" no delay on entering normal mode
set ttimeoutlen=0

" set cursor
let &t_SI = "\<Esc>[6 q"  " insert mode: ibeam
let &t_SR = "\<Esc>[4 q"  " replace mode: underline
let &t_EI = "\<Esc>[2 q"  " normal mode: block

" gvim
set guifont=InputMonoCondensed\ 9
" set guioptions-=m  " remove menu bar
set guioptions-=T  " remove toolbar
set guioptions-=r  " remove right scroll bar
set guioptions-=L  " remove left scroll bar

" disable register/yank limits
set viminfo-=<50,s10

" persistent undo
set undofile
set undodir=~/.vim/undo
silent call system('mkdir -p ' . &undodir)

" make system clipboard and VIM default register the same
" set clipboard^=unnamed,unnamedplus

" disable yank for single-char delete
noremap x "_x

" show relative line numbers, except in current line
" set number
" set relativenumber

" jump to last position on VIM start
augroup lastposition
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\"" | endif
augroup END

" move through wrapped lines
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" more responsive vim, really needed if relative numbers are enabled in term
set lazyredraw
set ttyfast

" disable mouse in neovim
if has('nvim')
    set mouse-=a
endif

" better TAB command autocomplete
set wildmenu
set wildmode=list:longest,full

" netrw
let g:netrw_liststyle=3  " tree style
let g:netrw_list_hide='.*\.swp$,\.DS_Store'
let g:netrw_sort_sequence='[\/]$'  " directories first
let g:netrw_sort_options='i'  " ignore case
let g:netrw_bufsettings = 'nomodifiable nomodified readonly nobuflisted nowrap'
let g:netrw_browse_split=4  " open files in previous window
let g:netrw_banner=0  " hide header
let g:netrw_winsize=25  " 25% width
let g:netrw_altv=1  " show on left side

autocmd BufNewFile,BufFilePre,BufRead Jenkinsfile set filetype=groovy
autocmd BufNewFile,BufFilePre,BufRead Dockerfile* set filetype=dockerfile
autocmd BufNewFile,BufFilePre,BufRead dircolors* set filetype=dircolors
autocmd BufNewFile,BufFilePre,BufRead */.dot/setup.conf set filetype=dosini

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ini=dosini', 'ocaml', 'rust', 'css', 'erb=eruby', 'ruby', 'c', 'cpp', 'dockerfile', 'js=javascript', 'yaml', 'jinja2']
let g:markdown_syntax_conceal = 0
let g:markdown_enable_mappings = 0
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_input_abbreviations = 0

" match parantheses etc. with % key
runtime macros/matchit.vim

" SPACE as leader key
nnoremap <SPACE> <Nop>
let g:mapleader="\<SPACE>"

" :w!! saves as sudo
cmap w!! w !sudo tee > /dev/null %

" stop highlighting search results
nnoremap <silent> <C-l> :nohl<CR><C-l>

" toggle line numbers
nnoremap <silent> <C-n> :set number!<CR>

" buffer on <Leader>1-9/left/right
nnoremap <leader><left> :bprev<CR>
nnoremap <leader><right> :bnext<CR>
nnoremap <leader>1 :buffer 1<CR>
nnoremap <leader>2 :buffer 2<CR>
nnoremap <leader>3 :buffer 3<CR>
nnoremap <leader>4 :buffer 4<CR>
nnoremap <leader>5 :buffer 5<CR>
nnoremap <leader>6 :buffer 6<CR>
nnoremap <leader>7 :buffer 7<CR>
nnoremap <leader>8 :buffer 8<CR>
nnoremap <leader>9 :buffer 9<CR>

" toggle markdown checkboxes
nnoremap <silent> <Leader>, :execute 's/^\(\s*[-+*]\?\s*\)\[ \]/\1[x]/'<cr>
nnoremap <silent> <Leader>. :execute 's/^\(\s*[-+*]\?\s*\)\[x]/\1[ ]/'<cr>

" surround with quotes/brackets
nnoremap <leader>*         viw<esc>a*<esc>hbi*<esc>lel
nnoremap <leader><leader>* viW<esc>a*<esc>hBi*<esc>lel
nnoremap <leader>'         viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader><leader>' viW<esc>a'<esc>hBi'<esc>lel
nnoremap <leader>"         viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader><leader>" viW<esc>a"<esc>hBi"<esc>lel
nnoremap <leader>(         viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>)         viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader><leader>( viW<esc>a)<esc>hBi(<esc>lel
nnoremap <leader><leader>) viW<esc>a)<esc>hBi(<esc>lel
nnoremap <leader>[         viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>]         viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader><leader>[ viW<esc>a]<esc>hBi[<esc>lel
nnoremap <leader><leader>] viW<esc>a]<esc>hBi[<esc>lel
nnoremap <leader>{         viw<esc>a}<esc>hbi{<esc>lel
nnoremap <leader>}         viw<esc>a}<esc>hbi{<esc>lel
nnoremap <leader><leader>{ viW<esc>a}<esc>hBi{<esc>lel
nnoremap <leader><leader>} viW<esc>a}<esc>hBi{<esc>lel

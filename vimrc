set encoding=utf-8
scriptencoding utf-8

filetype plugin on
syntax on
" set autoindent  " use indent from current line when making new line
set backspace=indent,eol,start  " when at beginning of line, pressing backspace joins with prev line
set whichwrap+=<,>,[,]  " moves to next line when pressing right at end of line
set linebreak  " wrap lines at words
set smarttab
" set laststatus=2  " always show statusbar
set autoread  " auto reload file when unchanged in vim and changed outside vim
set history=2000
set scrolloff=2  " scrolling shows one line extra
set hlsearch  " highlight search results
set incsearch  " search during input

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set updatetime=250

" system clipboard and VIM default register is the same
"   set clipboard^=unnamed,unnamedplus
" delete single chars without yanking them
noremap x "_x

" show relative line numbers, except in current line
" set number
" set relativenumber

" jump to last position on VIM start
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" move through wrapped lines
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" more responsive vim, really needed if relative numbers are enabled in term
set lazyredraw
set ttyfast

" disable mouse in neovim
if has("nvim")
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
map <C-_> :Lexplore<CR>

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ini=dosini']
let g:markdown_syntax_conceal = 0
let g:markdown_enable_mappings = 0
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_input_abbreviations = 0

if (has("termguicolors"))
    set termguicolors
endif

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

" buffer on <Leader>1-9
nnoremap <BS> :b#<CR>
nnoremap <leader><left> :bprev<CR>
nnoremap <leader><right> :bnext<CR>
nnoremap <leader><up> :b#<CR>
nnoremap <leader>1 :buffer 1<CR>
nnoremap <leader>2 :buffer 2<CR>
nnoremap <leader>3 :buffer 3<CR>
nnoremap <leader>4 :buffer 4<CR>
nnoremap <leader>5 :buffer 5<CR>
nnoremap <leader>6 :buffer 6<CR>
nnoremap <leader>7 :buffer 7<CR>
nnoremap <leader>8 :buffer 8<CR>
nnoremap <leader>9 :buffer 9<CR>

nnoremap <silent> <Leader>, :execute 's/^\(\s*[-+*]\?\s*\)\[ \]/\1[x]/'<cr>
nnoremap <silent> <Leader>. :execute 's/^\(\s*[-+*]\?\s*\)\[x]/\1[ ]/'<cr>

" surround with something
nnoremap <leader>z viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>Z viW<esc>a"<esc>hBi"<esc>lel
nnoremap <leader>u viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>U viW<esc>a)<esc>hBi(<esc>lel

""" PLUGINS

call plug#begin()

" " airline
" Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline'
" let g:airline_powerline_fonts = 1
" let g:airline_skip_empty_sections = 1
" let g:airline_section_c = '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
" let g:airline#extensions#default#layout = [
"   \ [ 'a', 'b', 'c' ],
"   \ [ 'error', 'warning' ]
"   \ ]
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_min_count = 2

Plug 'ervandew/supertab' | Plug 'sirver/ultisnips'
let g:UltiSnipsSnippetDirectories = ["snip"]
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

Plug 'raimondi/delimitmate'  " auto-close brackets

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } | Plug 'junegunn/fzf.vim'
let g:fzf_files_options = '--preview "$HOME/.bin/preview {}"'
let $FZF_DEFAULT_COMMAND = 'ag -g "" --nocolor --nogroup --files-with-matches'
let g:fzf_buffers_jump = 1  " jump to existing if possible
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader><space> :Lines<CR>
nnoremap <silent> <leader>n :Files<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>m :History<CR>
nnoremap <silent> <leader>o :Commits<CR>

Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }  " auto-uses ag, ack etc.
let g:grepper = {}
let g:grepper.highlight = 1
nnoremap <leader>g :Grepper<CR>
nnoremap <leader>G :Grepper -cword -noprompt<cr>

" TComment
Plug 'tomtom/tcomment_vim'
nnoremap <silent> <leader># :TComment<CR>
vnoremap <silent> <leader># :TComment<CR>

" gitgutter
Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
nmap <Leader>< <Plug>GitGutterNextHunk
nmap <Leader>> <Plug>GitGutterPrevHunk

" color schemes
Plug 'morhetz/gruvbox'
Plug 'sjl/badwolf'

" python
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = [ 'flake8' ]
let g:syntastic_python_flake8_args='--ignore=E501,W391,E402,E129'
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_style_error_symbol = "\u2717"
let g:syntastic_warning_symbol = "\u26A0"
let g:syntastic_style_warning_symbol = "\u26A0"
" highlight SyntasticErrorSign guifg=red guibg=NONE

Plug 'davidoc/taskpaper.vim', { 'for': 'taskpaper' }
highlight taskpaperDone ctermfg=243 guifg=#857f78
let g:task_paper_styles={ 'crit': 'guibg=#dd5010' }

Plug 'ap/vim-buftabline'
set hidden
let g:buftabline_show = 1

Plug 'ntpeters/vim-better-whitespace'

Plug 'pearofducks/ansible-vim'
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1
autocmd BufNewFile,BufFilePre,BufRead inventory/* set filetype=ansible_hosts
autocmd BufNewFile,BufFilePre,BufRead *.yml set filetype=ansible

Plug 'rhysd/committia.vim'
let g:committia_use_singlecolumn = 'always'

call plug#end()

" auto-install missing plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


""" COLOR SCHEME

" fallback color scheme
try
    set background=dark

    " GRUVBOX
    " colorscheme gruvbox
    highlight GruvboxGreenSign ctermbg=NONE guibg=NONE ctermfg=142 guifg=#b8bb26
    highlight GruvboxAquaSign ctermfg=108 ctermbg=NONE guifg=#8ec07c guibg=NONE
    highlight GruvboxRedSign ctermfg=167 ctermbg=NONE guifg=#fb4934 guibg=NONE

    " BADWOLF
    colorscheme badwolf
    let g:airline_theme='jellybeans'
catch
    colorscheme pablo
    highlight StatusLine term=bold,reverse ctermfg=11 ctermbg=242 guifg=yellow guibg=DarkGray
endtry

" show invisible chars
set list
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«
highlight SpecialKey ctermfg=240 guifg=#666666
highlight NonText ctermfg=240 guifg=#666666

" do not colorize gutter
highlight clear SignColumn

" dark line numbers and tilde symbols after EOF
highlight LineNr ctermfg=241 guifg=#555555
highlight NonText ctermfg=241 guifg=#555555

" make VIM background like terminal/gui background
highlight NonText guibg=#282a36 ctermbg=none
highlight Normal guibg=#282a36 ctermbg=NONE
highlight SignColumn guibg=#282a36 ctermbg=NONE
highlight LineNr guibg=#282a36 ctermbg=NONE


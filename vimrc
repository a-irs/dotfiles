set encoding=utf-8
scriptencoding utf-8

filetype plugin on
syntax on
" set autoindent  " use indent from current line when making new line
set backspace=indent,eol,start  " when at beginning of line, pressing backspace joins with prev line
set whichwrap+=<,>,[,]  " moves to next line when pressing right at end of line
set linebreak  " wrap lines at words
set smarttab
set laststatus=0  " never show statusbar
set autoread  " auto reload file when unchanged in vim and changed outside vim
set history=2000
set scrolloff=2  " scrolling shows one line extra
set hlsearch  " highlight search results
set incsearch  " search during input
set fillchars+=vert:│  " prettier split separator

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set updatetime=250

" persistent undo
set undofile
set undodir=~/.vim/undo
silent call system('mkdir -p ' . &undodir)

" make system clipboard and VIM default register the same
" set clipboard^=unnamed,unnamedplus

" delete single chars without yanking them
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
map <C-_> :Lexplore<CR>

autocmd BufNewFile,BufFilePre,BufRead Jenkinsfile set filetype=groovy

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ini=dosini']
let g:markdown_syntax_conceal = 0
let g:markdown_enable_mappings = 0
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_input_abbreviations = 0

if (has('termguicolors'))
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

" toggle markdown checkboxes
nnoremap <silent> <Leader>, :execute 's/^\(\s*[-+*]\?\s*\)\[ \]/\1[x]/'<cr>
nnoremap <silent> <Leader>. :execute 's/^\(\s*[-+*]\?\s*\)\[x]/\1[ ]/'<cr>

" surround with something
nnoremap <leader>z viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>Z viW<esc>a"<esc>hBi"<esc>lel
nnoremap <leader>u viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>U viW<esc>a)<esc>hBi(<esc>lel


""" PLUGINS

call plug#begin()

Plug 'ervandew/supertab' | Plug 'sirver/ultisnips'
let g:UltiSnipsSnippetDirectories = ['snip']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" auto-close brackets
Plug 'raimondi/delimitmate'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } | Plug 'junegunn/fzf.vim'
let g:fzf_files_options = '--preview "$HOME/.bin/preview {}" --no-exact --color=16 --cycle --no-mouse'
let $FZF_DEFAULT_COMMAND = 'ag -g "" --nocolor --nogroup --files-with-matches'
let g:fzf_buffers_jump = 1  " jump to existing if possible
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>o :Commits<CR>
nnoremap <silent> - :Files<CR>
nnoremap <silent> _ :History<CR>

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

" async linter
Plug 'w0rp/ale'
let g:ale_linters = { 'python': ['flake8'] }
let g:ale_python_flake8_options = '--ignore=E501,W391,E402,E129'
let g:ale_sign_warning = "\u26A0"
let g:ale_sign_style_warning = "\u26A0"
let g:ale_sign_error = "\u2717"
let g:ale_sign_style_error = "\u2717"
let g:ale_echo_msg_format = '%severity%: %s [%linter%]'
highlight ALEWarningSign guibg=NONE guifg=yellow
highlight ALEErrorSign guibg=NONE guifg=red

" Plug 'davidoc/taskpaper.vim', { 'for': 'taskpaper' }
" highlight taskpaperDone ctermfg=243 guifg=#857f78
" let g:task_paper_styles={ 'crit': 'guibg=#dd5010' }

Plug 'ap/vim-buftabline'
set hidden
let g:buftabline_show = 1

Plug 'ntpeters/vim-better-whitespace'

Plug 'pearofducks/ansible-vim'
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1
let g:ansible_with_keywords_highlight = 'Constant'
autocmd BufNewFile,BufFilePre,BufRead */playbooks/*.yml set filetype=yaml.ansible

Plug 'rhysd/committia.vim'
let g:committia_use_singlecolumn = 'always'

call plug#end()


" auto-install missing plugins
augroup pluginstall
    autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugInstall --sync | q
      \| endif
augroup END


""" COLOR SCHEME

" fallback color scheme
try
    set background=dark

    " GRUVBOX
    let g:gruvbox_italic=1
    colorscheme gruvbox
    highlight GruvboxGreenSign ctermbg=NONE guibg=NONE ctermfg=142 guifg=#b8bb26
    highlight GruvboxAquaSign ctermfg=108 ctermbg=NONE guifg=#8ec07c guibg=NONE
    highlight GruvboxRedSign ctermfg=167 ctermbg=NONE guifg=#fb4934 guibg=NONE

    " BADWOLF
    " colorscheme badwolf
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
" highlight NonText guibg=#282a36 ctermbg=none
" highlight Normal guibg=#282a36 ctermbg=NONE
" highlight SignColumn guibg=#282a36 ctermbg=NONE
" highlight LineNr guibg=#282a36 ctermbg=NONE


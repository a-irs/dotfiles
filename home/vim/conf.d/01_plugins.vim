call plug#begin()

Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 1  " jump to existing if possible
" uses $FZF_DEFAULT_COMMAND
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fh :History<CR>
nnoremap <silent> <Leader>fg :GFiles<CR>
nnoremap <silent> <Leader>fm :GFiles?<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>bx :bd<CR>
nnoremap <silent> <Leader>g :Rg<CR>

Plug 'ervandew/supertab' | Plug 'sirver/ultisnips'
let g:UltiSnipsSnippetDirectories = ['snip']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'eiginn/iptables-vim'
autocmd BufNewFile,BufFilePre,BufRead *.rules set filetype=iptables

" better ft=sh, see https://www.reddit.com/r/vim/comments/c6supj/vimsh_better_syntax_highlighting_for_shell_scripts/
Plug 'arzg/vim-sh'

" increase/decrease/toggle everything with ctrl+a/ctrl+x
Plug 'Konfekt/vim-CtrlXA'

" auto-close brackets
Plug 'tmsvg/pear-tree'
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_pairs = {
            \ '(': {'closer': ')'},
            \ '[': {'closer': ']'},
            \ '{': {'closer': '}'},
            \ "'": {'closer': "'"},
            \ '"': {'closer': '"'},
            \ '<!--': {'closer': ' -->'}
            \ }

Plug 'jaxbot/semantic-highlight.vim'
let g:semanticTermColors = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
let semanticEnableFileTypes = {'python': 'python', 'lua': 'lua', 'css': 'css'}
" re-highlight on save
augroup SemanticHL
    autocmd FileType python,lua
        \ autocmd! SemanticHL BufWritePost <buffer> :SemanticHighlight
augroup END

Plug 'chrisbra/Colorizer'
let g:colorizer_auto_filetype='css,html,conf,lua,sh'
let g:colorizer_colornames = 0  "do not colorize simple 'red', 'yellow', ...

" TComment
Plug 'tomtom/tcomment_vim'
nnoremap <silent> <leader># :TComment<CR>
vnoremap <silent> <leader># :TComment<CR>

Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
nmap <leader>< <Plug>(GitGutterNextHunk)
nmap <leader>> <Plug>(GitGutterPrevHunk)

" ALE async linter
Plug 'w0rp/ale'
let g:ale_python_mypy_options = '--cache-dir /tmp/mypy'
" https://github.com/koalaman/shellcheck/wiki/SC2119
" https://github.com/koalaman/shellcheck/wiki/SC2029
let g:ale_sh_shellcheck_exclusions = 'SC2119,SC2029'
let g:ale_yaml_yamllint_options='-d "{extends: default, rules: {line-length: disable, document-start: disable}}"'

" ALE appearance
let g:ale_sign_warning = "\u26A0"
let g:ale_sign_style_warning = "\u26A0"
let g:ale_sign_error = "\u2717"
let g:ale_sign_style_error = "\u2717"
let g:ale_echo_msg_format = '[%linter%] %severity%% code%: %s'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
highlight ALEWarningSign guibg=NONE guifg=yellow
highlight ALEErrorSign guibg=NONE guifg=red

Plug 'davidoc/taskpaper.vim', { 'for': 'taskpaper' }
let g:task_paper_styles={ 'crit': 'guibg=#dd5010' }
augroup vimrc-taskpaper
    autocmd!
    autocmd FileType taskpaper call s:taskpaper_setup()
augroup END
" set toggle-task binding the same as toggle-comment
function! s:taskpaper_setup()
    nnoremap <silent> <buffer> <Leader>#
    \ :call taskpaper#toggle_tag('done', taskpaper#date())<CR>
endfunction

Plug 'ap/vim-buftabline'
set hidden
let g:buftabline_show = 1

" show trailing whitespace, except in current line
Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_ctermcolor = '1'
let g:better_whitespace_guicolor = '#ff6e67'
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
let g:strip_only_modified_lines = 1

Plug 'vim-python/python-syntax', { 'for': 'python' }
let python_highlight_all = 1

Plug 'cespare/vim-toml', { 'for': 'toml' }

Plug 'pearofducks/ansible-vim'
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1
let g:ansible_with_keywords_highlight = 'Constant'
let g:ansible_template_syntaxes = { '*.conf.j2': 'conf', '*.rules.j2': 'iptables', '*.xml.j2': 'xml', '*.sh.j2': 'sh', '*.yml.j2': 'yaml.ansible', '*.py.j2': 'python', '*.jcfg.j2': 'conf', '*.rb.j2': 'ruby' }
autocmd BufNewFile,BufFilePre,BufRead */playbooks/*.yml set filetype=yaml.ansible

" verbose git commit message
Plug 'rhysd/committia.vim'
let g:committia_use_singlecolumn = 'always'

" highlight word under cursor
let g:Illuminate_delay = 100  " default: 250
let g:Illuminate_ftblacklist = ['gitcommit']
Plug 'RRethy/vim-illuminate'

" color schemes
" Plug 'morhetz/gruvbox'
" Plug 'sjl/badwolf'
Plug 'rhysd/vim-color-spring-night'
" Plug 'sainnhe/sonokai'
" Plug 'sainnhe/gruvbox-material'

call plug#end()


" auto-install missing plugins
augroup pluginstall
    autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugInstall --sync | q
      \| endif
augroup END

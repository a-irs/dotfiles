call plug#begin()

Plug 'ervandew/supertab' | Plug 'sirver/ultisnips'
let g:UltiSnipsSnippetDirectories = ['snip']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'eiginn/iptables-vim'
autocmd BufNewFile,BufFilePre,BufRead *.rules set filetype=iptables

" auto-close brackets
Plug 'raimondi/delimitmate'

Plug 'jaxbot/semantic-highlight.vim'
let g:semanticTermColors = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
let semanticEnableFileTypes = ['python', 'lua']
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

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git']
let g:signify_sign_show_count = 0
nmap <leader>< <plug>(signify-next-hunk)
nmap <leader>> <plug>(signify-prev-hunk)

" ALE async linter
Plug 'w0rp/ale'
" E501 = 80 characters
" W391 = blank line at end of file
" E129 = https://github.com/PyCQA/pycodestyle/issues/474
" E302 = expected 2 blank lines, found 1
let g:ale_python_flake8_options = '--ignore=E501,W391,E129,E302'
let g:ale_python_mypy_options = '--cache-dir /tmp/mypy'
" https://github.com/koalaman/shellcheck/wiki/SC2119
let g:ale_sh_shellcheck_exclusions = 'SC2119'
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

Plug 'vim-python/python-syntax', { 'for': 'python' }
let python_highlight_all = 1

Plug 'cespare/vim-toml', { 'for': 'toml' }

Plug 'pearofducks/ansible-vim'
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_keywords_highlight = 1
let g:ansible_with_keywords_highlight = 'Constant'
let g:ansible_template_syntaxes = { '*.conf.j2': 'conf', '*.rules.j2': 'iptables', '*.xml.j2': 'xml', '*.sh.j2': 'sh', '*.yml.j2': 'yaml.ansible', '*.py.j2': 'python', '*.jcfg.j2': 'conf' }
autocmd BufNewFile,BufFilePre,BufRead */playbooks/*.yml set filetype=yaml.ansible

" verbose git commit message
Plug 'rhysd/committia.vim'
let g:committia_use_singlecolumn = 'always'


" color schemes
" Plug 'morhetz/gruvbox'
" Plug 'sjl/badwolf'
Plug 'rhysd/vim-color-spring-night'

call plug#end()


" auto-install missing plugins
augroup pluginstall
    autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugInstall --sync | q
      \| endif
augroup END

call plug#begin()

Plug 'lambdalisue/vim-manpager'

" from /usr/share/vim/vim*/plugin/manpager.vim
" adapted so whichwrap and illuminate plugin works
command! -nargs=0 MYMANPAGER call s:MyManPager() | delcommand MYMANPAGER
function! s:MyManPager()
  " set nocompatible  " disabled, so whichwrap works
  if exists('+viminfofile')
    set viminfofile=NONE
  endif
  set noswapfile

  setlocal ft=man
  runtime ftplugin/man.vim
  setlocal buftype=nofile bufhidden=hide iskeyword+=: modifiable

  " Emulate 'col -b'
  silent keepj keepp %s/\v(.)\b\ze\1?//ge

  " Remove empty lines above the header
  call cursor(1, 1)
  let n = search(".*(.*)", "c")
  if n > 1
    exe "1," . n-1 . "d"
  endif
  setlocal nomodified readonly

  " syntax on  " disabled, so illuminate plugin works
endfunction


Plug 'tolecnal/icinga2-vim', { 'for': 'icinga2' }
autocmd BufNewFile,BufFilePre,BufRead */icinga/*/*.conf set filetype=icinga2

" filetypes pcre/pyre
Plug 'Galicarnax/vim-regex-syntax'

" filetype ps1
Plug 'PProvost/vim-ps1'

Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-d50%' }
else
    let g:fzf_layout = { 'down': '50%' }
endif
let g:fzf_buffers_jump = 1  " jump to existing if possible

" uses $FZF_DEFAULT_COMMAND
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fh :History<CR>
nnoremap <silent> <Leader><Tab> :History<CR>
nnoremap <silent> <Leader>fg :GFiles<CR>
nnoremap <silent> <Leader>fm :GFiles?<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>
nnoremap <silent> <Leader>bx :bd<CR>
nnoremap <silent> <Leader>g :Rg<CR>

Plug 'eiginn/iptables-vim', { 'for': 'iptables' }
autocmd BufNewFile,BufFilePre,BufRead *.rules set filetype=iptables

" better ft=sh, see https://www.reddit.com/r/vim/comments/c6supj/vimsh_better_syntax_highlighting_for_shell_scripts/
Plug 'arzg/vim-sh', { 'for': 'sh' }

" increase/decrease/toggle everything with ctrl+a/ctrl+x
Plug 'Konfekt/vim-CtrlXA'

Plug 'jaxbot/semantic-highlight.vim', { 'for': 'python,lua,css' }
let g:semanticTermColors = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
let g:semanticEnableFileTypes = {'python': 'python', 'lua': 'lua', 'css': 'css'}
" re-highlight on save
augroup SemanticHL
    autocmd FileType python,lua
        \ autocmd! SemanticHL BufWritePost <buffer> :SemanticHighlight
augroup END

Plug 'chrisbra/Colorizer'
let g:colorizer_auto_filetype='css,html,conf,lua,sh,dosini'
let g:colorizer_colornames = 0  "do not colorize simple 'red', 'yellow', ...

Plug 'tpope/vim-commentary'
nmap <leader># :Commentary<CR>
vmap <leader># :Commentary<CR>
autocmd FileType markdown,markdown.pandoc setlocal commentstring=<!--\ %s\ -->
autocmd FileType nasm setlocal commentstring=;\ %s

Plug 'airblade/vim-gitgutter'
" set background to same as SignColumn
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_map_keys = 0
nmap <leader>< <Plug>(GitGutterNextHunk)
nmap <leader>> <Plug>(GitGutterPrevHunk)

" ALE async linter
Plug 'w0rp/ale'
" https://github.com/koalaman/shellcheck/wiki/SC2119
" https://github.com/koalaman/shellcheck/wiki/SC2029
let g:ale_sh_shellcheck_exclusions = 'SC2119,SC2029'
let g:ale_yaml_yamllint_options='-d "{extends: default, rules: {line-length: disable, document-start: disable}}"'
let g:ale_nasm_nasm_options='-f elf64'

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


" COC

if hostname() =~ 'srv.'
else
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-json', 'coc-css', 'coc-jedi', 'coc-yaml', 'coc-vimlsp', 'coc-sh', 'coc-html', 'coc-pairs']

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

nmap <leader>cr <Plug>(coc-rename)
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)

" confirm completion with ENTER
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
endif

Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = '<c-n>'

Plug 'sirver/ultisnips'
let g:UltiSnipsSnippetDirectories = ['snip']


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
let g:Illuminate_delay = 100  " default: 0
let g:Illuminate_ftblacklist = ['gitcommit']
Plug 'RRethy/vim-illuminate'

" color schemes
" Plug 'morhetz/gruvbox'
" Plug 'sjl/badwolf'
Plug 'rhysd/vim-color-spring-night'
" Plug 'sainnhe/gruvbox-material'
" Plug 'ayu-theme/ayu-vim'

call plug#end()


" auto-install missing plugins
augroup pluginstall
    autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \|   PlugInstall --sync | q
      \| endif
augroup END

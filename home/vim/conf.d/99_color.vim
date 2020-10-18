if has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set t_Co=256
    set termguicolors
endif

set background=dark
try
    " GRUVBOX
    " let g:gruvbox_invert_selection = 0
    " colorscheme gruvbox
    " highlight GruvboxGreenSign ctermbg=NONE guibg=NONE ctermfg=142 guifg=#b8bb26
    " highlight GruvboxAquaSign ctermfg=108 ctermbg=NONE guifg=#8ec07c guibg=NONE
    " highlight GruvboxRedSign ctermfg=167 ctermbg=NONE guifg=#fb4934 guibg=NONE

    " GRUVBOX MATERIAL
    " let g:gruvbox_material_background = 'hard'
    " let g:gruvbox_material_disable_italic_comment = 1
    " colorscheme gruvbox-material

    " BADWOLF
    " colorscheme badwolf

    " SPRINGNIGHT
    colorscheme spring-night

    " SONOKAI
    " let g:sonokai_style = 'atlantis'
    " let g:sonokai_disable_italic_comment = 1
    " colorscheme sonokai
catch
    " fallback color scheme
    colorscheme default
    highlight StatusLine term=bold,reverse ctermfg=11 ctermbg=242 guifg=yellow guibg=DarkGray
endtry

" clear sidebar backgrounds (git gutter, line numbers)
highlight clear SignColumn
highlight clear LineNr

" show invisible chars
set list
set listchars=tab:▸\ ,extends:»,precedes:«
highlight SpecialKey ctermfg=240 guifg=#666666
highlight NonText ctermfg=240 guifg=#666666

" change VIM background to terminal background
" highlight NonText guibg=NONE ctermbg=NONE
" highlight Normal guibg=NONE ctermbg=NONE
" highlight SignColumn guibg=NONE ctermbg=NONE
" highlight LineNr guibg=NONE ctermbg=NONE

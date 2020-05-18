if has('termguicolors')
    set termguicolors
endif

set background=dark
try
    " GRUVBOX
    " let g:gruvbox_italic = 1
    " let g:gruvbox_invert_selection = 0
    " colorscheme gruvbox
    " highlight GruvboxGreenSign ctermbg=NONE guibg=NONE ctermfg=142 guifg=#b8bb26
    " highlight GruvboxAquaSign ctermfg=108 ctermbg=NONE guifg=#8ec07c guibg=NONE
    " highlight GruvboxRedSign ctermfg=167 ctermbg=NONE guifg=#fb4934 guibg=NONE

    " GRUVBOX MATERIAL
    " let g:gruvbox_material_background = 'hard'
    " colorscheme gruvbox-material

    " BADWOLF
    " colorscheme badwolf

    " SPRINGNIGHT
    colorscheme spring-night

    " SONOKAI
    " let g:sonokai_style = 'atlantis'
    " colorscheme sonokai
catch
    " fallback color scheme
    colorscheme default
    highlight StatusLine term=bold,reverse ctermfg=11 ctermbg=242 guifg=yellow guibg=DarkGray
endtry

" git gutter
highlight SignifySignDelete ctermbg=NONE  ctermfg=1
highlight SignifySignAdd    ctermbg=NONE  ctermfg=2
highlight SignifySignChange ctermbg=NONE  ctermfg=3

" clear gutter background
highlight clear SignColumn

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

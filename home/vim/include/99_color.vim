" fallback color scheme
set background=dark
try
    " GRUVBOX
    let g:gruvbox_italic=1
    let g:gruvbox_invert_selection=0
    colorscheme gruvbox
    highlight GruvboxGreenSign ctermbg=NONE guibg=NONE ctermfg=142 guifg=#b8bb26
    highlight GruvboxAquaSign ctermfg=108 ctermbg=NONE guifg=#8ec07c guibg=NONE
    highlight GruvboxRedSign ctermfg=167 ctermbg=NONE guifg=#fb4934 guibg=NONE

    " BADWOLF
    " colorscheme badwolf
catch
    colorscheme default
    highlight StatusLine term=bold,reverse ctermfg=11 ctermbg=242 guifg=yellow guibg=DarkGray
endtry

" show invisible chars
set list
set listchars=tab:▸\ ,extends:»,precedes:«
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


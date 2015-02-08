" open a NERDTree automatically when vim starts up
autocmd vimenter * NERDTreeTabsOpen
autocmd VimEnter * wincmd p

" CTRL+N toggle
map <C-n> :NERDTreeTabsToggle<CR>

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

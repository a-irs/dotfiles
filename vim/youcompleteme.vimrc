let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py" " set compiler flags for YCM autocompletion
set makeprg=make\ -C\ ../build " make command executed in ../build
nnoremap <F4> :make!<cr> " F4 builds project. '!' prevents jumping to error
nnoremap <F5> :!../build/main<cr> " F5 launches project

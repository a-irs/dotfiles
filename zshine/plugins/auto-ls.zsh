chpwd() {
    \ls -F --color=auto --group-directories-first
}
[[ "$TERM" != linux ]] && chpwd

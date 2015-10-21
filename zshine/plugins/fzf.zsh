alias fzf="ruby $ZSHINE_DIR/plugins/fzf/fzf --extended-exact --no-256"

__fsel() {
    command find . \
    \( -fstype 'dev' -o -fstype 'proc' \
        -o -path \*Cache\* \
        -o -path \*cache\* \
        -o -path \*/.atom/packages \
        -o -name \*.pyc \
    \) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 1d | cut -b3- | fzf -m | while read item; do
        printf '%q ' "$item"
    done
    echo
}

# CTRL-T - Paste the selected file path(s) into the command line
fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fsel)"
    zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

# CTRL-G - cd into the selected directory
fzf-cd-widget() {
    old_chpwd=$(which chpwd 2> /dev/null)
    unfunction chpwd
    cd "${$(command find . \
        \( -fstype 'dev' -o -fstype 'proc' \) -prune \
        -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m):-.}"
    eval "$old_chpwd"
    unset "$old_chpwd"
    zle reset-prompt
}
zle     -N    fzf-cd-widget
bindkey '^G' fzf-cd-widget

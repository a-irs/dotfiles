alias fzf="ruby $ZSHINE_DIR/plugins/fzf/fzf --extended-exact --no-256"

__fsel() {
    set -o nonomatch
    command find * \
           -type f -print \
        -o -type d -print \
        -o -type l -print 2> /dev/null | fzf -m | while read i; do
            printf '%q ' "$i"
        done
    echo
}

fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fsel)"
    zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

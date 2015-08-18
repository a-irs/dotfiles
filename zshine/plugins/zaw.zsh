source "$ZSHINE_DIR/plugins/zaw/zaw.zsh"

bindkey '^R' zaw-history
bindkey -M filterselect '^R' down-line-or-history
bindkey -M filterselect '^S' up-line-or-history
bindkey -M filterselect '^J' accept-search
bindkey -M filterselect '^M' accept-search

zstyle ':filter-select:highlight' error fg=red,bold
zstyle ':filter-select:highlight' title fg=blue
zstyle ':filter-select:highlight' matched fg=green,bold
zstyle ':filter-select' rotate-list yes
zstyle ':filter-select' case-insensitive yes
zstyle ':filter-select' extended-search yes

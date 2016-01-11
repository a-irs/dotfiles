source "$ZSHINE_DIR/plugins/zaw/zaw.zsh"

bindkey '^R' zaw-history

zstyle ':filter-select:highlight' error fg=red,bold
zstyle ':filter-select:highlight' title fg=blue
zstyle ':filter-select:highlight' matched fg=green,bold
zstyle ':filter-select' rotate-list yes
zstyle ':filter-select' extended-search yes
zstyle ':filter-select' case-insensitive yes

bindkey '^W' zaw-cdr

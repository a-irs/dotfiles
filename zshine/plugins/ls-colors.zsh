[[ -f "$ZSHINE_DIR/dircolors" ]] && eval $(dircolors -b "$ZSHINE_DIR/dircolors")

autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Use same colors for autocompletion
zmodload -a colors
zmodload -a autocomplete
zmodload -a complist
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

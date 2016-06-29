if [[ -f "$ZSHINE_DIR/dircolors" ]]; then
    [[ "$os" = Darwin ]] && eval $(gdircolors -b "$ZSHINE_DIR/dircolors")
    [[ "$os" = Linux  ]] && eval $(dircolors -b "$ZSHINE_DIR/dircolors")
fi

autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Use same colors for autocompletion
zmodload -a colors
zmodload -a autocomplete
zmodload -a complist
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

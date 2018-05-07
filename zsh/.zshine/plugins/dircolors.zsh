[[ "$commands[dircolors]" ]]  && eval $(dircolors  -b "$ZSHINE_DIR/plugins/dircolors.txt")
[[ "$commands[gdircolors]" ]] && eval $(gdircolors -b "$ZSHINE_DIR/plugins/dircolors.txt")

autoload colors; colors;

# Use same colors for autocompletion
zmodload -a colors
zmodload -a autocomplete
zmodload -a complist
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

[[ $os == Darwin ]] && export CLICOLOR=1

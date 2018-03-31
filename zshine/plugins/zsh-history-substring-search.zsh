source "$ZSHINE_DIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=magenta,fg=16,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=red,fg=16,bold"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

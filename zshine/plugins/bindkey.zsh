___prepend-sudo() {
    [[ $BUFFER != "sudo "* ]] && BUFFER="sudo $BUFFER" && zle end-of-line
}
zle -N ___prepend-sudo
bindkey "^[a" ___prepend-sudo

bindkey '^r' history-incremental-search-backward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char
bindkey '^[[1;5C' forward-word                      # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                     # [Ctrl-LeftArrow] - move backward one word
bindkey "${terminfo[kcbt]}" reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards
bindkey "^Y" _expand_alias
bindkey "^P" copy-prev-shell-word
bindkey '^H' edit-command-line
bindkey -M menuselect '\e^M' accept-and-menu-complete # select multiple entries in TAB-completion with ESC+Return

fg-toggle() { fg; }
zle -N fg-toggle
bindkey '^Z' fg-toggle

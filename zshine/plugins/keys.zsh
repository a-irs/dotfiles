zmodload zsh/terminfo

# emacs bindings
bindkey -e

bindkey '^r' history-incremental-search-backward

bindkey "^[[3~" delete-char  # DEL key
bindkey '^[[1;5C' forward-word  # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word  # [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[3;5~' kill-word  # CTRL+DEL
bindkey -M emacs '^H' backward-kill-word  # CTRL+Backspace
bindkey "${terminfo[kcbt]}" reverse-menu-complete  # [Shift-Tab] - move through the completion menu backwards
bindkey "^Y" _expand_alias
bindkey "^P" copy-prev-shell-word

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line

bindkey -M menuselect '\e^M' accept-and-menu-complete # select multiple entries in TAB-completion with ESC+Return

fg-toggle() { fg; }
zle -N fg-toggle
bindkey '^Z' fg-toggle

# insert last arguments with CTRL+k/j
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^k" copy-earlier-word
bindkey "^j" insert-last-word

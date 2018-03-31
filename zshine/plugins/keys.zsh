# find out keys with CTRL+V <keysequence>
# or sed -n l

# terminfo capabilites with: man 5 terminfo

# ^ = CTRL
# ^[ or \e = ESC

zmodload zsh/terminfo

# set word seperators for forward-word, backward-kill-word and so on
# to seperate on everything (e.g. slash, dot, ...)
# default: WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS=''

# emacs bindings
bindkey -e

# del: remove one char
bindkey "$terminfo[kdch1]" delete-char
bindkey '^[[3~' delete-char

# ctrl+left/right: move one word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ctrl+del/backspace: remove one word
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word

# shift+tab: move through completion menu backwards
bindkey "${terminfo[kcbt]}" reverse-menu-complete
bindkey "^[[Z"              reverse-menu-complete

# ctrl+y: expand alias
bindkey "^Y" _expand_alias

# ctrl+p: copy and paste last word
bindkey "^P" copy-prev-shell-word

# ctrl+g: edit command line in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line

# esc+ret: select multiple entries in TAB-completion
bindkey -M menuselect '\e^M' accept-and-menu-complete

# ctrl+z: toggle job
fg-toggle() { fg; }
zle -N fg-toggle
bindkey '^Z' fg-toggle

# ctrl+k/j: insert last arguments
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^k" copy-earlier-word
bindkey "^j" insert-last-word

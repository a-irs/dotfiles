source "$ZSHINE_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# main
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=8,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=8,bold'

# pattern
ZSH_HIGHLIGHT_PATTERNS+=('rm -r*' 'fg=red,bold')
ZSH_HIGHLIGHT_PATTERNS+=('rm -fr*' 'fg=red,bold')
ZSH_HIGHLIGHT_PATTERNS+=('wipe *' 'fg=red,bold')
ZSH_HIGHLIGHT_PATTERNS+=('dd *' 'fg=red,bold')

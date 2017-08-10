source "$ZSHINE_DIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

FAST_HIGHLIGHT_STYLES[unknown-token]='fg=8,bold'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=cyan'
FAST_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
FAST_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
FAST_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
FAST_HIGHLIGHT_STYLES[command]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[precommand]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
FAST_HIGHLIGHT_STYLES[path]='fg=blue,bold'
FAST_HIGHLIGHT_STYLES[globbing]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
FAST_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
FAST_HIGHLIGHT_STYLES[assign]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[redirection]='fg=yellow,bold'
FAST_HIGHLIGHT_STYLES[comment]='fg=8,bold'

# only available in zsh-syntax-highlighting
FAST_HIGHLIGHT_STYLES[path_prefix]='fg=blue'
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

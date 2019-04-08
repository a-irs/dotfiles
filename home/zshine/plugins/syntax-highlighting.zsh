source "$ZSHINE_DIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# man/whatis is slow otherwise
unset "FAST_HIGHLIGHT[chroma-man]"
unset "FAST_HIGHLIGTH[chroma-whatis]"

FAST_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
FAST_HIGHLIGHT_STYLES[assign]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
FAST_HIGHLIGHT_STYLES[back-or-dollar-double-quoted-argument]='fg=cyan'
FAST_HIGHLIGHT_STYLES[back-quoted-argument]='none'
FAST_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
FAST_HIGHLIGHT_STYLES[command]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
FAST_HIGHLIGHT_STYLES[comment]='fg=black,bold'
FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=cyan'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
FAST_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
FAST_HIGHLIGHT_STYLES[globbing]='fg=red,bold'
FAST_HIGHLIGHT_STYLES[hashed-command]='none'
FAST_HIGHLIGHT_STYLES[history-expansion]='fg=yellow'
FAST_HIGHLIGHT_STYLES[path]='fg=blue,bold'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[path_pathseparator]='none'
FAST_HIGHLIGHT_STYLES[precommand]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[redirection]='fg=yellow,bold'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=cyan'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=white,bold'
FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow,bold'
FAST_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
FAST_HIGHLIGHT_STYLES[suffix-alias]='none'
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=black,bold'
FAST_HIGHLIGHT_STYLES[variable]='fg=red'

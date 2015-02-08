source $ZSHINE_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

ZSH_HIGHLIGHT_PATTERNS+=('rm -r*' 'fg=red,bold')
ZSH_HIGHLIGHT_PATTERNS+=('rm -fr*' 'fg=red,bold')
ZSH_HIGHLIGHT_PATTERNS+=('wipe *' 'fg=red,bold')

ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=white'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path_approx_pathseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing_pathseparator]='fg=cyan'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green,bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,bold'

ZSH_HIGHLIGHT_STYLES[unknown-token]='underline,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='bold'

ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,bg=black'

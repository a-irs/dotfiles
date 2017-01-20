autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file ~/.zsh_recent-dirs +
zstyle ':chpwd:*' recent-dirs-max 50

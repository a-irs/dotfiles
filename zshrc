[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh
[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

[[ "$TERM" = linux ]] && return
tmux attach &> /dev/null
[[ "$TERM" =~ screen ]] || exec tmux

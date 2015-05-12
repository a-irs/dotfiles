[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh
[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

tmux attach &> /dev/null
[[ $TERM =~ screen ]] || exec tmux

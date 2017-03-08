[ -f ~/.zshrc.prefix ] && source ~/.zshrc.prefix || return 0
source ~/.zshine/init.zsh
[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

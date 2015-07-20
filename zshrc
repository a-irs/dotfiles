[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh
[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

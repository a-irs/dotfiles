[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh
[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

if [[ $TERM == xterm-termite && -f /etc/profile.d/vte.sh ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

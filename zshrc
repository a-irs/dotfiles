[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh

if [[ "$TERM" == xterm-termite && -f /etc/profile.d/vte.sh ]]; then
  source /etc/profile.d/vte.sh
  __vte_osc7 &> /dev/null
fi

[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

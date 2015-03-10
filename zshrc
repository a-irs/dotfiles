[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh

if [[ $HOST == srv ]]; then
    [ "$(command ls -A /var/tmp/offsite-backup/dell 2> /dev/null)" ] || echo -e "\n${RED}WARNING: encfs for dell not mounted!${RESET}"
    [ "$(command ls -A /var/tmp/offsite-backup/desktop 2> /dev/null)" ] || echo -e "\n${RED}WARNING: encfs for desktop not mounted!${RESET}"
fi

[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

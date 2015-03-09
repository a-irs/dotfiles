[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh

if [[ $HOST == srv ]]; then
    [ "$(command ls -A /tmp/offsite-backup/dell)" ] || echo -e "\n${RED}WARNING: encfs for dell not mounted!${RESET}"
    [ "$(command ls -A /tmp/offsite-backup/desktop)" ] || echo -e "\n${RED}WARNING: encfs for desktop not mounted!${RESET}"
fi

[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

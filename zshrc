[ -f ~/.zshine/setup.zsh ] && source ~/.zshine/setup.zsh

if [[ $HOST == srv ]]; then
    [ "$(ls -A /media/data-local/encrypted-upload/unlocked/dell)" ] || echo -e "\n${RED}WARNING: encfs for dell not mounted!${RESET}"
    [ "$(ls -A /media/data-local/encrypted-upload/unlocked/desktop)" ] || echo -e "\n${RED}WARNING: encfs for desktop not mounted!${RESET}"
fi

[ -f ~/.zshrc.append ] && source ~/.zshrc.append || return 0

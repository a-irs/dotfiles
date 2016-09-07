TODO_FILE=~/.todo

[[ -s "$TODO_FILE" ]] || return
content=$(cat -s "$TODO_FILE")

printf "\n$(tput setaf 6)%s$(tput sgr0)\n" "${content}"


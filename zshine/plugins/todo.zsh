f=~/.todo

[[ -f "$f" ]] || return
content=$(cat -s "$f")

echo "\n$(tput setaf 6)${content}$(tput sgr0)"


TODO_FILES=(
    ~/.todo
    ~/Documents/TODO.md
)

for f in ${TODO_FILES[@]}; do
    [[ -s "$f" ]] || continue
    content=$(cat "$f" | grep '\S*\[ \] ' | sed 's/\[ \] /• /')
    printf "\n$(tput setaf 2)%s$(tput sgr0)\n" "${content}"
done


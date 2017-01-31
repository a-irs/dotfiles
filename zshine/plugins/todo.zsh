TODO_FILES=(
    ~/.todo
    ~/Documents/TODO.md
    ~/Documents/TODO.taskpaper
)

for f in ${TODO_FILES[@]}; do
    [[ -s "$f" ]] || continue
    content=$(cat "$f" | grep -v '@done' | grep '\S*- ' | sed 's/- /• /')
    echo "$content" | grep --color -E '@.*|$'
done


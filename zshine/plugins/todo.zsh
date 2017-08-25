TODO_FILES=(
    ~/.todo
    ~/Documents/todo.md
    ~/Documents/todo.taskpaper
)

for f in ${TODO_FILES[@]}; do
    [[ -s "$f" ]] || continue
    content=$(cat "$f" | grep -v '@done' | grep '\S*- ' | sed 's/- /• /' | perl -pe 's/\t/    /g')
    echo "$content" | grep --color -E '@.*|$'
done

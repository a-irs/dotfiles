TODO_FILES=(
    ~/.todo
    ~/doc/todo.taskpaper
    ~/doc/todo.md
    ~/Documents/todo.taskpaper
    ~/Documents/todo.md
)

for f in ${TODO_FILES[@]}; do
    [[ -s "$f" ]] || continue
    content=$(cat "$f" | grep -v '@done' | grep '\S*- ' | sed 's/- /• /' | perl -pe 's/\t/    /g')
    echo "$content" | grep --color -E '@.*|$'
done

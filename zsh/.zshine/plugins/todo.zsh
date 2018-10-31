TODO_FILES_GLOBAL=(
    ~/.todo
    ~/doc/todo.taskpaper
    ~/doc/todo.md
    ~/Documents/todo.taskpaper
    ~/Documents/todo.md
)

TODO_FILES=(
    ~/doc/todo_$HOST.taskpaper
    ~/doc/todo_$HOST.md
)

for f in ${TODO_FILES[@]}; do
    [[ -s "$f" ]] || continue
    content=$(cat "$f" | grep -v '@done' | grep '\S*- ' | sed 's/- /• /' | perl -pe 's/\t/    /g')
    echo "$content" | grep --color -E '@.*|$'
done

for f in ${TODO_FILES_GLOBAL[@]}; do
    [[ -s "$f" ]] || continue
    content=$(cat "$f" | grep -v '@done' | grep '\S*- ' | sed 's/- /• /' | perl -pe 's/\t/    /g')
    echo "$content" | grep --color -E '@.*|$'
done

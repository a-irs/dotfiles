#!/usr/bin/env bash

todo_files=(
    ~/.todo
    ~/{doc,Documents}/todo.{taskpaper,md}
)

todo() {
    for file in "${todo_files[@]}"; do
        if [[ -f "$file" ]]; then
            vim + "$file"
            return
        fi
    done
    echo "No todo files found: $todo_files"
}

_show_todos() {
    for file in "${todo_files[@]}"; do
        [[ -s "$file" ]] || continue
        content=$(grep -v '@done' "$file" | sed 's/- /• /')
        echo "$content" | grep --color -E '@.*|$'
    done
    unset file
}
_show_todos

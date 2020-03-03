#!/usr/bin/env bash

showtodo() {
    local todo_files=(~/.todo ~/{doc,Documents}/todo.{taskpaper,md})

    for file in "${todo_files[@]}"; do
        [[ -s "$file" ]] || continue
        content=$(grep -v '@done' "$file" | sed 's/- /• /' | perl -pe 's/\t/    /g')
        echo "$content" | grep --color -E '@.*|$'
    done
    unset file
}

showtodo

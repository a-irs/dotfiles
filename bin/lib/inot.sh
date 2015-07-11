#!/usr/bin/env bash

set -e

[[ -z $1 || -z $2 ]] && exit 1

file=$1
cmd=$2

red() {
    echo "$(tput setaf 1)${*}$(tput sgr0)"
}

green() {
    echo "$(tput setaf 2)${*}$(tput sgr0)"
}

make() {
    timestamp=$(date +%H:%M:%S)
    echo -n "$(tput bold)[$timestamp] $(tput setaf 5)${1/$HOME/\~} $(tput setaf 3)${2/$HOME/\~}$(tput sgr0) → "

    if "$1" "$2"; then
        green "DONE"
    else
        red "EXIT $?"
    fi
}

make "$cmd" "$file"
while true; do
    inotifywait -mrq -e create -e move -e modify --format %w%f "$file" | while read f
    do
        [[ ! -f "$f" ]] && continue
        make "$cmd" "$f"
    done
done

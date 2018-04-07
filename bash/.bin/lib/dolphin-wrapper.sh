#!/usr/bin/env bash

[[ ! -f /usr/bin/dolphin-emu ]] && echo "dolphin not installed" && exit 1
[[ -z "$1" ]] && echo "argument missing" && exit 1
[[ ! -f "$1" ]] && echo "invalid argument $1" && exit 1

name=$(basename "$1")
name=${name%.*}
name=${name// - /-}
name=${name// /-}
name=${name//./}
name=${name//_/-}
name=${name,,}
dir=$HOME/.dolphin/$name

mkdir -p "$dir"
dolphin-emu --batch --user="$dir" --exec="$1"

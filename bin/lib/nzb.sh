#!/usr/bin/env bash

set -e

DEST="root@srv:/srv/drop"

# PROMPT
YELLOW=$(tput bold;tput setaf 3)
RED=$(tput bold;tput setaf 1)
RESET=$(tput sgr0)
echo

for SRC in "$@"; do
    if [[ ! -f $SRC ]]; then
        echo "$RED$(basename "$SRC") not found, skipping.$RESET"
        echo ""
        continue
    fi
    package_name=$(basename -s ".nzb" "$SRC")
    read -r -e -i "$package_name" -p "${YELLOW}NAME:     $RESET" input
    package_name="${input:-$package_name}"

    read -r -e -i "$password" -p "${YELLOW}PASSWORD: $RESET" input
    password="${input:-$password}"

    if [ -z "$password" ]; then
        d=$(printf "%q" "$DEST/$package_name.nzb")
        scp -q -C "$SRC" "$d"
    else
        d=$(printf "%q" "$DEST/$package_name{{$password}}.nzb")
        scp -q -C "$SRC" "$d"
    fi
    trash-put -- "$SRC"
done

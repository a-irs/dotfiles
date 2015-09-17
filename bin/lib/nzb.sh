#!/usr/bin/env bash

set -e

DEST="root@srv:/srv/drop"
SRC=$1

[ -z "$SRC" ] && echo "no file as input" && exit 1
[ ! -f "$SRC" ] && echo "file not found" && exit 1

# PROMPT
YELLOW=$(tput bold;tput setaf 3)
RESET=$(tput sgr0)
echo

package_name=$(basename -s ".nzb" "$1")
read -e -i "$package_name" -p $YELLOW"NAME:     "$RESET input
package_name="${input:-$package_name}"

read -e -i "$password" -p $YELLOW"PASSWORD: "$RESET input
password="${input:-$password}"

if [ -z "$password" ]; then
    d=$(printf "%q" "$DEST/$package_name.nzb")
    scp -C "$SRC" "$d"
else
    d=$(printf "%q" "$DEST/$package_name{{$password}}.nzb")
    scp -C "$SRC" "$d"
fi
trash-put -- "$SRC"

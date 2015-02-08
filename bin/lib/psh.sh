#!/usr/bin/env bash

PROGRAM="psh"
DIR="$HOME/doc/$PROGRAM-store"
OPENSSL_OPTIONS="-aes-256-cbc -base64"

set -e

println() {
    echo -e "\n\033[33;1m>>> $1\033[0m"
}

printlne() {
    echo -e "\n\033[31;1m>>> $1\033[0m"
}

tmpdir() {
    [[ -n $SECURE_TMPDIR ]] && return
    local template="$PROGRAM.XXXXXXXXXXXXX"
    if [[ -d /dev/shm && -w /dev/shm && -x /dev/shm ]]; then
        SECURE_TMPDIR="$(mktemp -d "/dev/shm/$template")"
        remove_tmpfile() {
            rm -rf "$SECURE_TMPDIR"
        }
        trap remove_tmpfile INT TERM EXIT
    else
        echo "/dev/shm missing"
        return 1
    fi
}

cmd_new() {
    [ -f "$DIR/$1" ] && echo "store '$1' already exists" && exit 1
    tmpdir
    local tmp_file="$(mktemp -u "$SECURE_TMPDIR/XXXXX")-${1/ /_}.txt"
    $EDITOR "$tmp_file"
    if [ -f "$tmp_file" ]; then
        openssl enc -e $OPENSSL_OPTIONS -in "$tmp_file" -out "$DIR/$1"
    else
        printlne "creation of '$1' aborted"
    fi
}

cmd_show() {
    check_file "$1"
    read -s -p "password: " PASS
    echo ""
    echo ""
    echo "$PASS" | openssl enc -d -pass stdin $OPENSSL_OPTIONS -in "$DIR/$1" 2> /dev/null || printlne "wrong password for store '$1'"
}

cmd_edit() {
    check_file "$1"
    read -s -p "password: " PASS
    tmpdir
    local tmp_file="$(mktemp -u "$SECURE_TMPDIR/XXXXX")-${1/ /_}.txt"
    echo "$PASS" | openssl enc -d -pass stdin $OPENSSL_OPTIONS -in "$DIR/$1" -out "$tmp_file" &> /dev/null
    if [[ ${PIPESTATUS[1]} -eq 0 ]]; then
        $EDITOR "$tmp_file"
        echo "$PASS" | openssl enc -e -pass stdin $OPENSSL_OPTIONS -in "$tmp_file" -out "$DIR/$1"
    else
        printlne "wrong password for store '$1'"
    fi
}

cmd_rm() {
    check_file "$1"
    rm -i "$DIR/$1"
}

cmd_mv() {
    check_file "$1"
    mv -i "$DIR/$1" "$DIR/$2"
}

cmd_ls() {
    echo ""
    ls -1 --color=auto "$DIR"
}

check_file() {
    if [ ! -f "$DIR/$1" ]; then
        printlne "no store named '$1' found"
        exit 1
    fi
}


if [ -z $EDITOR ]; then
    echo '$EDITOR' not set && exit 1
fi

mkdir -p "$DIR"
if [[ "$1" == "new" ]]; then
    [[ -n "$2" ]] && cmd_new "$2" || echo "$PROGRAM new <name>"
elif [[ "$1" == "show" ]]; then
    [[ -n "$2" ]] && cmd_show "$2" || echo "$PROGRAM show <name>"
elif [[ "$1" == "edit" ]]; then
    [[ -n "$2" ]] && cmd_edit "$2" || echo "$PROGRAM edit <name>"
elif [[ "$1" == "rm" ]]; then
    [[ -n "$2" ]] && cmd_rm "$2" || echo "$PROGRAM rm <name>"
elif [[ "$1" == "ls" ]]; then
    cmd_ls "$2"
elif [[ "$1" == "mv" ]]; then
    [[ -n "$2" ]] && [[ -n "$3" ]] && cmd_mv "$2" "$3" || echo "$PROGRAM mv <old_name> <new_name>"
else
    cmd_ls
fi

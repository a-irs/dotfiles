#!/usr/bin/env bash

this_dir="$(dirname "$(readlink -f "$0")")"

print_error() {
    echo -e "\033[1;31m$*\033[0m"
}

print_info() {
    echo -e "\033[33m$*\033[0m"
}

mklink() {
    dest=~/.$1
    mkdir -p "$(dirname "$dest")"
    ln --force --symbolic --relative --no-target-directory --no-dereference "$this_dir/$1" "$dest" 2> /dev/null
    if [[ $? != 0 ]]; then
        print_error "error creating link to $dest"
    else
        print_info "${dest/$HOME/\~} <== ${this_dir/$HOME/\~}/$1"
    fi
}

dotfiles=(
    bin
    config/htop/htoprc
    config/ranger/rc.conf
    config/ranger/scope.sh
    gitconfig
    nano-syntax
    nanorc
    zprofile
    zshine
    zshrc
)

for f in "${dotfiles[@]}"; do mklink "$f"; done

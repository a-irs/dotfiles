#!/usr/bin/env bash

set -e

BASEDIR=/var/lib/container

die() {
    echo "$1" && exit 1
}

yellow() {
    echo -e "\n$(tput setaf 3)$1$(tput init)\n"
}

_remove() {
    [[ -z "$1" ]] && die "USAGE: nspawn.sh remove <name>"
    name=$1
    dir=$BASEDIR/$name
    [[ ! -d "$dir" ]] && die "'$dir' does not exist"

    read -p "Do you really want to remove '$name' in '$dir'? [y/N] " answer
    if [[ "$answer" == y || "$answer" == Y ]]; then
        sudo rm -rf "$dir"
        yellow "removed '$dir'"
    fi
}

_create() {
    [[ -z "$1" ]] && die "USAGE: nspawn.sh create <name>"
    name=$1
    dir=$BASEDIR/$name
    [[ -d "$dir" ]] && die "'$dir' already exists"

    yellow "installing base named '$name' to '$dir' ..."
    cleanup() {
        yellow "cleaning up '$dir' ..."
        sudo rm -rf "$dir"
    }
    trap cleanup INT
    sudo mkdir -p "$dir"
    sudo pacstrap -c -d "$dir" bash coreutils diffutils file filesystem findutils gawk grep inetutils iproute2 iputils less man-db man-pages nano pacman procps-ng psmisc sed which net-tools shadow dhcpcd gcc-libs glibc gettext gzip bzip2 netctl systemd-sysvcompat zsh git
    sudo rm -f "$dir/etc/securetty"
    sudo chmod a+x "$dir"
}

_start() {
    [[ -z "$1" ]] && die "USAGE: nspawn.sh start <name>"
    name=$1
    dir=$BASEDIR/$name
    [[ ! -d "$dir" ]] && die "'$dir' does not exist"

    sudo systemctl start "systemd-nspawn@$name.service"
}

_stop() {
    [[ -z "$1" ]] && die "USAGE: nspawn.sh stop <name>"
    name=$1
    dir=$BASEDIR/$name
    [[ ! -d "$dir" ]] && die "'$dir' does not exist"

    sudo systemctl stop "systemd-nspawn@$name.service"
}

_log() {
    name=$1
    journalctl -M "$name"
}

_login() {
    name=$1
    sudo machinectl login "$name"
}

if [[ $1 == create ]]; then
    _create "$2"
elif [[ $1 == remove ]]; then
    _remove "$2"
elif [[ $1 == start ]]; then
    _start "$2"
elif [[ $1 == stop ]]; then
    _stop "$2"
elif [[ $1 == log ]]; then
    _log "$2"
elif [[ $1 == login ]]; then
    _login "$2"
elif [[ "$1" == list || "$1" == ls ]]; then
    ls --color -lAh "$BASEDIR"
else
    die "NOT IMPLEMENTED"
fi

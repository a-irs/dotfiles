#!/usr/bin/env bash

green() { echo -en "\e[1;32m$@\e[0m"; }

red() { echo -en "\e[1;31m$@\e[0m"; }

sstatus() {
    status=$(systemctl show "$1" | grep ActiveState | cut -d= -f 2)
    if [[ "$status" == "active" ]]; then
        green "$1\n"
    else
        red "$1\n"
    fi
}

docker_active=$(docker ps | tail -n +2 | awk '{print $NF}')
docker_inactive=$(docker ps -a -f="status=exited" | tail -n +2)
dstatus() {
    if echo "$docker_active" | grep -q $1; then
        green "$1.docker\n"
    else
        red "$1.docker\n"
    fi
}


echo ""
sstatus media-data.mount
sstatus media-data1.mount
sstatus media-data2.mount
sstatus media-data3.mount
sstatus media-data4.mount
echo ""
pydf | grep -v '/var/lib/docker'
echo ""
echo -n "$(tput setaf 1)"
docker ps -f status=exited | tail +2
docker ps -f status=dead | tail +2
echo -n "$(tput sgr0)"

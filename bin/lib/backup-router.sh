#!/usr/bin/env bash

DEST=${HOME}
STAMP=$(date +%Y%m%d%H%M)
read -s -p "password: " PASS

ddwrt() {
    [ -z $1 ] || [ -z $2 ] || [ -z $3 ] && echo "invalid number of arguments" && return
    host=${1}
    username=${2}
    password=${3}
    name="nvrambak.bin"
    curl "http://${username}:${password}@${host}/${name}" > "${DEST}/${STAMP}_${name}"
}

tomato() {
    [ -z $1 ] || [ -z $2 ] || [ -z $3 ] && echo "invalid number of arguments" && return
    host=${1}
    username=${2}
    password=${3}
    name="tomato_v128_m1DF700.cfg"
    curl "http://${username}:${password}@${host}/cfg/${name}?_http_id=TIDe9b6b9c506cd69bc" > "${DEST}/${STAMP}_${name}"
}

ddwrt tpl root ${PASS}
tomato router root ${PASS}

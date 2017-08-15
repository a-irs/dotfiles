#!/usr/bin/env bash

set -e
export LC_ALL=C

out="/root/filesgit"

lsfiles() { find "$1" -type f | sort -hf > "$out/$(basename "$1").txt"; }

lsfiles /media/data1
lsfiles /media/data2
lsfiles /media/data3
lsfiles /media/data4

git -C "$out" add -v --all
git -C "$out" commit -am "[automatic commit]"

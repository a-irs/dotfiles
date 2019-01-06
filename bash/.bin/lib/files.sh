#!/usr/bin/env bash

set -eu
# deterministic sort
export LC_ALL=C

out=~/work/filesgit

lsfiles() { find "$1" -type f | sort -hf > "$out/$(basename "$1").txt"; }
for d in /media/data?; do lsfiles "$d"; done

git -C "$out" add -v --all
git -C "$out" commit -am "[automatic commit]"

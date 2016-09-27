#!/usr/bin/env bash

set -e
export LC_ALL=C

if (($# == 2)); then
    set1=($1/*.bz2)
    set2=($2/*.bz2)
    for i in "${!set1[@]}"; do
        diff -U 0 <(bzcat "${set1[$i]}" | sort) <(bzcat "${set2[$i]}" | sort) | tail -n +4 | grep -v '^@@ ' | sed 's|/media/||' | sed 's/^-/\x1b[31m- /;s/^+/\x1b[32m+ /;s/$/\x1b[0m/'
    done
    exit
fi

out="/root/files/$(date +%Y-%m-%d)"
mkdir -p "$out"

lsfiles() { find "$1" -type f | sort -hf | bzip2 > "$out/$(basename "$1").bz2"; }

lsfiles /media/data1
lsfiles /media/data2
lsfiles /media/data3
lsfiles /media/data4


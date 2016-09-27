#!/usr/bin/env bash

set -e

out="/root/files/$(date +%Y-%m-%d)"
mkdir -p "$out"

lsfiles() { find "$1" -type f | sort -hf | lzma > "$out/$(basename "$1").lzma"; }

lsfiles /media/data1
lsfiles /media/data2
lsfiles /media/data3
lsfiles /media/data4


#!/usr/bin/env bash

set -e

[[ -z "$1" ]] && exit 1

out=$(basename "$1")
out=${out//.md/}
css=~/.bin/lib/markdown-build.css

pandoc -V lang=de \
--mathjax='http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML' \
--to=html5 \
--number-sections \
--standalone --smart --css "$css" \
-o ~/"${out}.html" "$1"

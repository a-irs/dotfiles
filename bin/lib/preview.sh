#!/usr/bin/env bash

set -e

path=$1
width="${2:-$(tput cols)}"
height="${3:-$(tput lines)}"

filename="${path##*/}"
[[ ! -e "$path" ]] && { echo "ERROR: '$filename' does not exist"; exit; }
[[ -d "$path" ]] && { echo "ERROR: '$filename' is a directory"; exit; }
[[ ! -r "$path" ]] && exec sudo -n "$0" "$@"

mime_type=$(file --mime-type -Lb -- "$path")
mime_encoding=$(file --mime-encoding -Lb -- "$path")
extension="${filename##*.}"
extension="${extension,,}" # lower case

#highlight() { command highlight "$@"; test $? = 0 -o $? = 141; } # wraps highlight to treat exit code 141 (killed by SIGPIPE) as success

trim() { head -n "$height"; }
remove_blank() { sed '/./,$!d'; } # remove blank lines at top of file
remove_double_blank() { cat -s; } # remove multiple blank lines
highlight_dirs() { GREP_COLOR='1;33' grep -E --color=always '(.)*/|$'; } # TODO: not working in ranger
highlight() {
    command highlight --out-format=ansi "$1" 2> /dev/null || \
    command highlight --out-format=ansi --syntax=conf "$1"
}

# echo "-----------------------------"
# echo "$mime_type"
# echo "$mime_encoding"
# echo "$filename"
# echo "$extension"
# echo "-----------------------------"

case "$extension" in
    bz|bz2|gz|lz|lzh|lzma|lzo|tar|tbz|tbz2|tgz|tlz|txz|xz )
        tar tf "$path" | trim | highlight_dirs; exit ;;
    zip )
        zipinfo -2tz "$path" | trim | highlight_dirs; exit ;;
    html|html|xhtml )
        elinks -dump 1 -dump-color-mode 1 "$path" | remove_blank | remove_double_blank | trim; exit ;;
esac

case "$mime_type" in
    application/pdf )
        pdftotext -l 10 -nopgbrk -q "$path" - | remove_blank | remove_double_blank | trim; exit ;;
    text/* | */xml | application/postscript )
        highlight "$path" | remove_blank | remove_double_blank | trim; exit ;;
    video/* | audio/* | image/* )
        mediainfo "$path" | remove_blank | remove_double_blank | trim | sed 's/  \+:/ --/;'; exit ;;
esac

printf "$(tput bold; tput setaf 5)%s\n" "$(file -b -- "$path")" | fmt -s -w "$width"
printf "$(tput bold; tput setaf 5)%s\n" "================"

strings "$path" | tr '\n' ' ' | fmt -s -w "$width" | trim

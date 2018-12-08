#!/usr/bin/env bash

set -eu

path=$1
width="${2:-$(tput cols)}"
height="${3:-$(tput lines)}"

filename="${path##*/}"

trim() { head -n "$height"; }
if [[ "$(uname)" = Darwin ]]; then
    wrap() { cat; }
#    wrap() { gfmt -s -t -w "$width"; }
else
    wrap() { fmt -s -t -w "$width"; }
fi
remove_blank() { sed '/./,$!d'; } # remove blank lines at top of file
remove_double_blank() { cat -s; } # remove multiple blank lines
highlight_dirs() { GREP_COLOR='1;33' grep -E --color=always '(.)*/|$'; } # TODO: not working in ranger

highlight() {
    command highlight --out-format=ansi "$1" 2> /dev/null || \
    command highlight --out-format=ansi --syntax=conf "$1" 2> /dev/null \
    || cat "$1";
}
showbin() {
    zcat "$1" 2> /dev/null || cat "$1" | xxd | trim | wrap;
}

preview_tar() { tar tf "$path" | trim | highlight_dirs; }
preview_zip() { zipinfo -2tz "$path" | trim | highlight_dirs; }
preview_htm() { elinks -dump 1 -dump-color-mode 1 "$path" | remove_blank | remove_double_blank | trim | wrap; }
preview_pdf() { pdftotext -l 10 -nopgbrk -q "$path" - | remove_blank | remove_double_blank | trim | wrap; }
preview_txt() { highlight "$path" | remove_blank | remove_double_blank | trim | wrap; }
preview_med() { mediainfo "$path" | remove_blank | remove_double_blank | trim | sed 's/  \+:/ --/;' | wrap; }
preview_json() { jq -C . "$path" | trim; }

mime_type=$(file --mime-type -Lb -- "$path")
extension="${filename##*.}"
#extension="${extension,,}" # lower case

# echo "-----------------------------"
# echo "$mime_type"
# echo "$filename"
# echo "$extension"
# echo "-----------------------------"

case "$extension" in
    bz|bz2|gz|lz|lzh|lzma|lzo|tar|tbz|tbz2|tgz|tlz|txz|xz)
        preview_tar && exit ;;
    zip)
        preview_zip && exit ;;
    plist|CodeResources|failurerequests)
    command highlight --out-format=ansi --syntax=xml "$path" && exit ;;
    rrd)
        rrdinfo "$path" && exit ;;
    html|xhtml)
        preview_htm && exit ;;
    json)
        preview_json && exit ;;
esac

case "$mime_type" in
    application/json )
        preview_json && exit ;;
    application/pdf )
        preview_pdf && exit ;;
    text/* | */xml | application/postscript )
        preview_txt && exit ;;
    video/* | audio/* | image/* )
        preview_med && exit ;;
esac

c=''
[[ -t 1 ]] && c=$(tput bold; tput setaf 5)
printf "${c}%s\n" "$(file -b -- "$path")" | wrap
printf "${c}%s\n" "================"
[[ -t 1 ]] && tput sgr0

#showbin_compressed "$path" 2> /dev/null
showbin "$path"

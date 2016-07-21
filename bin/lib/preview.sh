#!/usr/bin/env bash

export LC_ALL=C

path=$1
width="${2:-$(tput cols)}"
height="${3:-$(tput lines)}"

filename="${path##*/}"
[[ ! -e "$path" ]] && { echo "ERROR: '$filename' does not exist"; exit; }
[[ -d "$path" ]] && { echo "ERROR: '$filename' is a directory"; exit; }
[[ ! -r "$path" ]] && exec sudo -n "$0" "$@"

#highlight() { command highlight "$@"; test $? = 0 -o $? = 141; } # wraps highlight to treat exit code 141 (killed by SIGPIPE) as success

trim() { head -n "$height"; }
if [[ "$(uname)" = Darwin ]]; then
    wrap() { cat; }
    wrap() { gfmt -s -t -w "$width"; }
else
    wrap() { fmt -s -t -w "$width"; }
fi
remove_blank() { sed '/./,$!d'; } # remove blank lines at top of file
remove_double_blank() { cat -s; } # remove multiple blank lines
highlight_dirs() { GREP_COLOR='1;33' egrep --color=always '(.)*/|$'; } # TODO: not working in ranger
highlight() { command highlight --out-format=ansi "$1" 2> /dev/null || command highlight --out-format=ansi --syntax=conf "$1" 2> /dev/null || cat "$1"; }
showbin() { strings -6 "$1" | tr '\n' ' ' | wrap | trim; }
showbin_compressed() { zcat "$1" | strings -6 | tr '\n' ' ' | wrap | trim; }

preview_tar() { tar tf "$path" | trim | highlight_dirs; }
preview_zip() { zipinfo -2tz "$path" | trim | highlight_dirs; }
preview_htm() { elinks -dump 1 -dump-color-mode 1 "$path" | remove_blank | remove_double_blank | trim | wrap; }
preview_pdf() { pdftotext -l 10 -nopgbrk -q "$path" - | remove_blank | remove_double_blank | trim | wrap; }
preview_txt() { highlight "$path" | remove_blank | remove_double_blank | trim | wrap; }
preview_med() { mediainfo "$path" | remove_blank | remove_double_blank | trim | sed 's/  \+:/ --/;' | wrap; }

mime_type=$(file --mime-type -Lb -- "$path")
extension="${filename##*.}"
#extension="${extension,,}" # lower case

# echo "-----------------------------"
# echo "$mime_type"
# echo "$filename"
# echo "$extension"
# echo "-----------------------------"

case "$extension" in
    bz|bz2|gz|lz|lzh|lzma|lzo|tar|tbz|tbz2|tgz|tlz|txz|xz )
        preview_tar && exit ;;
    zip )
        preview_zip && exit ;;
    plist|CodeResources|failurerequests )
	command highlight --out-format=ansi --syntax=xml "$path" && exit ;;
    rrd )
        rrdinfo "$path" && exit ;;
    html|html|xhtml )
        preview_htm && exit ;;
esac

case "$mime_type" in
    application/pdf )
        preview_pdf && exit ;;
    text/* | */xml | application/postscript )
	preview_txt && exit ;;
    video/* | audio/* | image/* )
        preview_med && exit ;;
esac

printf "$(tput bold; tput setaf 5)%s\n" "$(file -b -- "$path")" | wrap
printf "$(tput bold; tput setaf 5)%s\n" "================"

#showbin_compressed "$path" 2> /dev/null
showbin "$path"

#!/usr/bin/env bash

set -euo pipefail

path=$1
width="${2:-$(tput cols)}"
height="${3:-$(tput lines)}"

filename="${path##*/}"

trim() { head -n "$height"; }
if [[ "$(uname)" = Darwin ]]; then
    wrap() { gfmt -s -t -w "$width"; }
else
    wrap() { fmt -s -t -w "$width"; }
fi
remove_blank() { sed '/./,$!d'; } # remove blank lines at top of file
remove_double_blank() { cat -s; } # remove multiple blank lines
highlight_dirs() { GREP_COLOR='1;33' grep -E --color=always '(.)*/|$'; } # TODO: not working in ranger

showbin() { zcat "$path" 2> /dev/null || cat "$path" | xxd | trim | wrap; }

preview_tar() { tar tf "$path" | trim | highlight_dirs; }
preview_zip() { zipinfo -2tz "$path" | trim | highlight_dirs; }
preview_htm() { elinks -dump 1 -dump-color-mode 1 "$path" | remove_blank | remove_double_blank | trim | wrap; }
preview_pdf() { pdftotext -l 10 -nopgbrk -q "$path" - | remove_blank | remove_double_blank | trim | wrap; }
preview_txt() { cat "$path" | remove_blank | remove_double_blank | trim | wrap; }
preview_med() { mediainfo "$path" | remove_blank | remove_double_blank | trim | sed 's/  \+:/ --/;' | wrap; }
preview_json() { jq -C . "$path" | trim; }
preview_sshkey() { file -Lb -- "$path"; ssh-keygen -l -f "$path"; echo ""; cat "$path" | trim; }
preview_plist() { temp=$(mktemp); plutil -convert xml1 -o "$temp" -- "$path"; cat "$temp" | trim | wrap; rm -f "$temp"; }
preview_cert() { openssl x509 -noout -text -in "$path" | perl -pe 's/\S+([0-9a-z][0-9a-z]:){14}$/XXXXXXXXXX/g' | grep -v 'XXXXXXXXXX$' | trim | wrap; }

file_type=$(file -Lb -- "$path")

tput bold; tput setaf 5
printf '%s\n' "$file_type" | wrap
printf '%s\n' "================"
tput sgr0

if [[ -d "$path" ]]; then
    ls -lhF "$path"; exit
fi

case "$file_type" in
    *" private key") preview_sshkey; exit ;;
    *" public key") preview_sshkey; exit ;;
    "PEM certificate") preview_cert; exit ;;
esac

extension="${filename##*.}"
# extension="${extension,,}" # lower case
case "$extension" in
    bz|bz2|gz|lz|lzh|lzma|lzo|tar|tbz|tbz2|tgz|tlz|txz|xz)
        preview_tar; exit ;;
    zip)
        preview_zip; exit ;;
    rrd)
        rrdinfo "$path"; exit ;;
    html|xhtml)
        preview_htm; exit ;;
    json)
        preview_json; exit ;;
    padl|plist)
        preview_plist; exit ;;
esac

mime_type=$(file --mime-type -Lb -- "$path")
case "$mime_type" in
    application/json )
        preview_json; exit ;;
    application/pdf )
        preview_pdf; exit ;;
    text/* | */xml | application/postscript )
        preview_txt; exit ;;
    video/* | audio/* | image/* )
        preview_med; exit ;;
esac


#showbin_compressed "$path" 2> /dev/null
showbin

#!/usr/bin/env bash
# ranger supports enhanced previews.  If the option "use_preview_script"
# is set to True and this file exists, this script will be called and its
# output is displayed in ranger.  ANSI color codes are supported.

# NOTES: This script is considered a configuration file.  If you upgrade
# ranger, it will be left untouched. (You must update it yourself.)
# Also, ranger disables STDIN here, so interactive scripts won't work properly

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | success. display stdout as preview
# 1    | no preview | failure. display no preview at all
# 2    | plain text | display the plain content of the file
# 3    | fix width  | success. Don't reload when width changes
# 4    | fix height | success. Don't reload when height changes
# 5    | fix both   | success. Don't ever reload
# 6    | image      | success. display the image $cached points to as an image preview

# Meaningful aliases for arguments:
path="$1"    # Full path of the selected file
width="$2"   # Width of the preview pane (number of fitting characters)
height="$3"  # Height of the preview pane (number of fitting characters)
cached="$4"  # Path that should be used to cache image previews

maxln=200    # Stop after $maxln lines.  Can be used like ls | head -n $maxln

# Find out something about the file:
mimetype=$(file --mime-type -Lb -- "$path")
mimeencoding=$(file --mime-encoding -Lb -- "$path")
extension=$(/bin/echo "${path##*.}" | tr "[:upper:]" "[:lower:]")

# Functions:
# runs a command and saves its output into $output.  Useful if you need
# the return value AND want to use the output in a pipe
try() { output=$(eval '"$@"'); }

# writes the output of the previously used "try" command
dump() { /bin/echo "$output"; }

# a common post-processing function used after most commands
trim() { head -n "$maxln"; }

# remove blank lines at top of file
remove_blank() { sed '/./,$!d'; }

# remove multiple blank lines
remove_double_blank() { cat -s; }

# wraps highlight to treat exit code 141 (killed by SIGPIPE) as success
highlight() { command highlight "$@"; test $? = 0 -o $? = 141; }

case "$extension" in
    7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
    rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z)
        atool --quiet --list "$path" | trim | tail -n +3; exit 0;;
    zip)
        try zipinfo -2tz "$path" && { dump | trim; exit 0; } ;;
    rar)
        try unrar -p- lb "$path" && { dump | trim; exit 0; } || exit 1;;
    pdf)
        try pdftotext -l 10 -nopgbrk -q "$path" - && \
            { dump | trim | fmt -s -w "$width"; exit 0; } || exit 1;;
    torrent)
        try transmission-show "$path" && { dump | trim; exit 5; } || exit 1;;
    htm|html|xhtml)
        try w3m    -dump "$path" && { dump | trim | fmt -s -w "$width"; exit 4; }
        try lynx   -dump "$path" && { dump | trim | fmt -s -w "$width"; exit 4; }
        try elinks -dump "$path" && { dump | trim | fmt -s -w "$width"; exit 4; }
        ;; # fall back to highlight/cat if the text browsers fail
esac

case "$mimetype" in
    text/* | */xml | application/postscript )
        try highlight --out-format=ansi "$path" && { dump | trim | remove_blank | remove_double_blank; exit 5; } || exit 2;;
    image/* )
        img2txt --gamma=0.6 --width="$width" "$path" && exit 4 || exit 1;;
    video/* | audio/* )
        mediainfo "$path" | trim | sed 's/  \+:/ --/;'; exit 5
esac

case "$mimeencoding" in
    *binary* )
        try echo "$(tput bold; tput setaf 1)BINARY FILE: $(file -b -- "$path")" && { dump | trim; exit 5; } || exit 2 ;;
esac

exit 1

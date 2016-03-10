#!/usr/bin/env bash

em() {
    echo ""
    echo "--------------------------------------------------"
    echo "$(tput setaf 2;tput bold)${1}$(tput sgr0;tput init)"
    echo "--------------------------------------------------"
}

echo ""
read -er -p "$(tput setaf 1)ONLY CONTINUE IF YOU ARE IN THE FOLDER OF THE DOWNLOADED MOVIE$(tput sgr0;tput init) "

DEST=/media/data/videos/movies

echo ""
while [[ -z "$MOVIE" ]]; do
    read -er -p "movie:   " MOVIE
done
while [[ -z "$YEAR" ]]; do
    read -er -p "year:    " YEAR
done

this=$(basename "$PWD")
this=${this// /.}
read -er -i "$this" -p "release: " REL

FOLDER="$MOVIE ($YEAR)"
if [[ $MOVIE == "Der "* ]]; then
    FOLDER="${MOVIE/Der /}, Der ($YEAR)"
elif [[ $MOVIE == "Die "* ]]; then
    FOLDER="${MOVIE/Die /}, Die ($YEAR)"
elif [[ $MOVIE == "Das "* ]]; then
    FOLDER="${MOVIE/Das /}, Das ($YEAR"
elif [[ $MOVIE == "Ein "* ]]; then
    FOLDER="${MOVIE/Ein /}, Ein ($YEAR)"
elif [[ $MOVIE == "Eine "* ]]; then
    FOLDER="${MOVIE/Eine /}, Eine ($YEAR)"
elif [[ $MOVIE == "The "* ]]; then
    FOLDER="${MOVIE/The /}, The ($YEAR)"
elif [[ $MOVIE == "A "* ]]; then
    FOLDER="${MOVIE/A /}, A ($YEAR)"
elif [[ $MOVIE == "An "* ]]; then
    FOLDER="${MOVIE/An /}, An ($YEAR)"
fi

em ":: make destionation folder"
mkdir -pv "$DEST/$FOLDER"

em ":: move video file"
mv -v -- *.mkv "$DEST/$FOLDER/$MOVIE.mkv" 2> /dev/null
mv -v -- *.avi "$DEST/$FOLDER/$MOVIE.avi" 2> /dev/null
mv -v -- *.mp4 "$DEST/$FOLDER/$MOVIE.mp4" 2> /dev/null
mv -v -- *.m4v "$DEST/$FOLDER/$MOVIE.m4v" 2> /dev/null

em ":: create nfo, release information"
mv -v -- *.nfo "$DEST/$FOLDER/#$REL" 2> /dev/null
touch "$DEST/$FOLDER/#$REL" 2> /dev/null

em ":: move subtitles (rename manually)"
shopt -s globstar
mv -v -- *.srt *.idx *.sub **/*.srt **/*.idx **/*.sub "$DEST/$FOLDER/" 2> /dev/null

em ":: remove unneeded files"
rm -rvf -- proof Proof sample Sample *-sample.* *-Sample.* *-proof.* *-Proof.* 2> /dev/null

em "→ \'$DEST/$FOLDER\'"

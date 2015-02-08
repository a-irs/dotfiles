#!/usr/bin/env bash

DIR=~/tmp/downloads

# don't show "nothing found for *.zip"
shopt -s nullglob

mkdir -p $DIR/temp
mv -n $DIR/*.tmp $DIR/*~ $DIR/*.nzb $DIR/Kontoauszuege*.pdf $DIR/TranscriptOfRecords*.pdf --target-directory="$DIR/temp" 2> /dev/null

mkdir -p $DIR/archives
mv -n $DIR/*.zip $DIR/*.gz $DIR/*.deb $DIR/*.7z $DIR/*.rar $DIR/*.xz $DIR/*.bz2 $DIR/*.jar $DIR/*.crx --target-directory="$DIR/archives" 2> /dev/null

mkdir -p $DIR/images
mv -n $DIR/*.jpg $DIR/*.jpeg $DIR/*.png $DIR/*.gif $DIR/*.bmp --target-directory="$DIR/images" 2> /dev/null

mkdir -p $DIR/text
mv -n $DIR/*.md $DIR/*.cfg $DIR/*.conf $DIR/*.txt $DIR/*.xml $DIR/*.js $DIR/*.css $DIR/*.htm $DIR/*.html $DIR/*.pl $DIR/*.csv $DIR/*.sql $DIR/*.py $DIR/*.sh $DIR/*.colors $DIR/*.qtcurve $DIR/*.ics --target-directory="$DIR/text" 2> /dev/null

mkdir -p $DIR/documents
mv -n $DIR/*.pdf $DIR/*.odf --target-directory="$DIR/documents" 2> /dev/null

mkdir -p $DIR/binary
mv -n $DIR/*.bin $DIR/*.img $DIR/*.iso $DIR/*.sqlite --target-directory="$DIR/binary" 2> /dev/null

for f in $DIR/*; do
    if [ -f "$f" ]; then
        type=$(file -b "$f")
        if [[ $type == *text* ]] || [[ $type == *signature* ]] || [[ $type == *ASCII* ]] || [[ $type == *UTF-8* ]]; then
            mv -n "$f" "$DIR/text"
        fi
    fi
done

#!/usr/bin/env zsh

#[ -z $1 ] && exit 1
#[ -z $2 ] && exit 1

INPUT="/media/data/photos"
OUTPUT="/srv/dropbox/media/photos-dslr"

# copy directory structure
rsync -a -f"+ */" -f"- *" "$INPUT"/ "$OUTPUT"

# convert images
unsetopt CASE_GLOB
files=($INPUT/**/*.(jpg|jpeg|tif|tiff|psd)(.))
i=1
c=0
for f in $files; do
    of="${OUTPUT}${f/$INPUT/}"
    ext=${of/*./}
    [[ $ext != "JPG" && $ext != "jpg" ]] && of=$of.jpg
   
    if [ -f "$of" ]; then
        : #echo "$i/$#files: output file already exists: $of"
    else 
        echo "$i/$#files: converting to $of"
        if [[ $ext == "PSD" || $ext == "psd" ]]; then
            # flatten psd
            convert -auto-orient -resize "960x960>" -quality 60% -strip "$f""[0]" "$of"
        else
            convert -auto-orient -resize "960x960>" -quality 60% -strip "$f" "$of"        
        fi
        c=$(($c+1))
    fi
    i=$(($i+1))
done

echo "\nSummary: $c of $#files files converted, $(($#files-$c)) skipped"

find "$OUTPUT" -type d -empty -exec rmdir {} \; 2> /dev/null

# delete non-existing
#rsync -a --delete --existing --ignore-existing "$INPUT"/ "$OUTPUT"

chown -R 1044:1044 $OUTPUT

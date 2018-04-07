#!/usr/bin/env zsh

INPUT="/media/data/photos"
OUTPUT="/srv/dropbox/media/photos-dslr"

# copy directory structure
rsync -a -f"+ */" -f"- *" "$INPUT"/ "$OUTPUT"

# convert images
unsetopt CASE_GLOB
files=($INPUT/**/*.(jpg|jpeg|tif|tiff|psd)(.))
for f in $files; do
    of="${OUTPUT}${f/$INPUT/}"
    ext=${of/*./}
    [[ $ext != "JPG" && $ext != "jpg" ]] && of=$of.jpg  # so .psd becomes .jpg.psd
   
    if [ ! -f "$of" ]; then
        echo "output: $of"
        if [[ $ext == "PSD" || $ext == "psd" ]]; then
            convert -auto-orient -resize "960x960>" -quality 60% -strip "$f""[0]" "$of"  # flatten psd
        else
            convert -auto-orient -resize "960x960>" -quality 60% -strip "$f" "$of"        
        fi
    fi
done

find "$OUTPUT" -type d -empty -exec rmdir {} \; 2> /dev/null

chown -R 1044:1044 $OUTPUT

#!/bin/sh

# settings
PL_FILE='/run/user/1000/gvfs/smb-share:server=pogo1.home,share=share/music/playlists/CD_K_1.m3u'
EXT='.mp3'
DEST_DIR="$HOME/test/"$(basename -s .m3u $PL_FILE)

# preliminary
mkdir -p $DEST_DIR
cd $(dirname $PL_FILE)

i=1
while read line; do 
	
	# extract id3
	OUT=`exiftool -artist -title "$line" | cut -d ':' -f 2`
	ARTIST=`echo "$OUT" | sed -n '1p'`
	TITLE=`echo "$OUT" | sed -n '2p'`
	
	# leading zero
	NUM="$(printf '%02d' "$i")"
	
	# action
	DEST=`echo $NUM - ${ARTIST:1} - ${TITLE:1}$EXT`
	cp -a "$line" "$DEST_DIR"/"$DEST"
	echo $DEST
    
    # increment counter
    i=`expr $i + 1`
    
done < $PL_FILE

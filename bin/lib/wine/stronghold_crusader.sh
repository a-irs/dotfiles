#!/bin/sh

PREFIX='/wine/StrongholdCrusader'
EXE='/run/media/alex/DATA/GAMES/StrongholdCrusader/Stronghold_Crusader.exe'
MOUNT='/run/media/alex/DATA'

sudo mount $MOUNT

echo 'PREFIX:' ${PREFIX}
echo 'EXE:' ${EXE}

env WINEPREFIX=${PREFIX} wine ${EXE}

sudo umount $MOUNT

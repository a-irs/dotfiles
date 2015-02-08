#!/bin/sh

PRE='/wine/PhotoshopCS6'
EXE='/wine/PhotoshopCS6/drive_c/apps/ps/PhotoshopCS6Portable.exe'
ARC='win64'

env WINEPREFIX="$PRE" WINEARCH="$ARC" wine "$EXE"

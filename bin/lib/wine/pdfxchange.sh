#!/bin/bash

PREFIX='/wine/pdfxchange'
EXE="/wine/pdfxchange/drive_c/Program Files/pdfxchange/PDFXCview.exe"

cd "$(dirname "$1")"
env WINEPREFIX="$PREFIX" wine "$EXE" "$(basename "$1")"

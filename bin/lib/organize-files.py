#!/usr/bin/env python

import os
import glob
import shutil
import subprocess
import fnmatch

def mv_exts(dir, dict):
    for k, v in dict.items():
        os.makedirs(dir + os.sep + k, exist_ok=True)
        for f in v:
            g = glob.glob(dir + os.sep + f)
            for src in g:
                shutil.move(src, dir + os.sep + k)

def mv_unknown(dir, dict):

    # make list of tuples with (file, type)
    files = []
    for f in os.listdir(dir):
        if os.path.isfile(dir + os.sep + f):
            t = file_type(dir + os.sep + f)
            files.append((dir + os.sep + f, t))

    # move files according to dict
    for f, t in files:
        for k, v in dict.items():
            for comp in v:
                if fnmatch.fnmatch(t, comp):
                    shutil.move(f, dir + os.sep + k)
                    break

def file_type(file):
    p = subprocess.Popen(["file", "-b", file],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    output, errors = p.communicate()
    return bytes.decode(output).strip()

# settings
directory = os.path.expanduser("~/tmp/downloads")
ext_dict = {  "temp":      ["*.tmp", "*.nzb", "Kontoauszuege*.pdf", "TranscriptOfRecords*.pdf"],
              "archives":  ["*.zip", "*.gz", "*.deb", "*.7z", "*.rar", "*.xz", "*.bz2", "*.jar", "*.crx"],
              "images":    ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp"],
              "text":      ["*.md", "*.cfg", "*.conf", "*.txt", "*.xml", "*.js", "*.css", "*.htm", "*.html", "*.pl", "*.csv", "*.sql", "*.py", "*.sh", "*.colors", "*.qtcurve", "*.ics"],
              "documents": ["*.pdf", "*.odf", "*.pptx", "*.ppt", "*.xls", "*.xlsx", "*.doc", "*.docx"],
              "binary":    ["*.bin", "*.img", "*.iso", "*.sqlite", "*.pkg", "*.sprx"] }
type_dict = { "text":      ["*text*", "*signature*", "*ascii*", "*utf-8*"] }

# do stuff
mv_exts(directory, ext_dict)
mv_unknown(directory, type_dict)

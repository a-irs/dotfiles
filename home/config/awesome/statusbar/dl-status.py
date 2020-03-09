#!/usr/bin/env python

from xmlrpc import client
import math
import sys


def convert_size(size_bytes):
    if size_bytes == 0:
        return "0B"
    size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
    i = int(math.floor(math.log(size_bytes, 1024)))
    p = math.pow(1024, i)
    s = round(size_bytes / p, 2)
    return "%s %s" % (s, size_name[i])


server = client.ServerProxy('http://nzb.home/xmlrpc')
status = server.status()

l = server.listgroups(1)
download = l[0] if l else None

if not download:
    sys.exit(0)

s = {}
s['Rate'] = str(convert_size(status['DownloadRate']) + "/s")
s['Status'] = download['Status']
s['Name'] = download['NZBName']
s['SizeTotal'] = download['FileSizeMB']
s['SizeDL'] = download['DownloadedSizeMB']

if s['Status'] in ["DOWNLOADING", "EXECUTING_SCRIPT"]:
    out = f"{s['SizeDL']}/{s['SizeTotal']} ({s['Rate']})"
else:
    out = f"{s['Status']}"

out = out + f" -- {s['Name']}"

print(out)

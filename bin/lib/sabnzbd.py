#!/usr/bin/env python

import sys
from urllib.request import urlopen
import json

SERVER = 'srv:8080'
API_KEY = '24eb3337bf38c3a052ae9ce8a5983370'

def print_info(js):
    if not js['jobs']:
        print('No downloads active.')
    else:
        print_jobs(js['jobs'])
        mbleft = pretty_size(js['mbleft'], "GB")
        timeleft = js['timeleft']
        speed = pretty_size(js['kbpersec'], "MB/s")
        print("\n%s left" % mbleft)
        print("%s" % speed)

def print_jobs(js):
    for job in js:
        timeleft = job['timeleft']
        sizeleft = pretty_size(job['mbleft'], "GB")
        filename = job['filename'].split("/")[0]
        print('\033[0;32mdone in', timeleft + '\033[0m', "|", '\033[0;33m' + sizeleft + '\033[0m', "|", filename)

def print_history(js):
    for job in js['history']['slots']:
        status = job['status']
        if status == 'Completed':
            status = '\033[0;32m' + status + ':\033[0m'
        elif status == 'Extracting':
            status = '\033[0;35m' + status + ':\033[0m'
        name = job['name']
        size = '\033[0;33m(' + job['size'] + ')\033[0m'
        print(status + " " + name + " " + size)

def pretty_size(b, suffix):
    return "{:.2f}".format(b / 1024) + " " + suffix

def main():
    if len(sys.argv) == 1:
        print()
        try:
            h = urlopen('http://' + SERVER + '/api?apikey=' + API_KEY + '&mode=qstatus&output=json')
            if h.status == 200:
                content = h.read().decode('utf-8')
                print_info(json.loads(content))
            else:
                print("HTTP ERROR " + str(h.status))
        except (urllib.error.HTTPError, urllib.error.URLError):
            print("Error")

    if len(sys.argv) > 1 and sys.argv[1] == "history":
        print()
        try:
            h = urlopen('http://' + SERVER + '/api?apikey=' + API_KEY + '&mode=history&output=json')
            if h.status == 200:
                content = h.read().decode('utf-8')
                print_history(json.loads(content))
            else:
                print("HTTP ERROR " + str(h.status))
        except (urllib.error.HTTPError, urllib.error.URLError):
            print("Error")

if __name__ == '__main__':
    main()

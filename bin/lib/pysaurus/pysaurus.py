#!/usr/bin/env python3

import json
import sys
from urllib.request import urlopen
from urllib.parse import quote

RESET = '\033[' + str(0) + 'm'
BOLD = '\033[' + str(1) + 'm'
DIM = '\033[' + str(2) + 'm'
MAGENTA = '\033[' + str(35) + 'm'
CYAN = '\033[' + str(36) + 'm'
BLUE = '\033[' + str(34) + 'm'
GREEN = '\033[' + str(32) + 'm'
YELLOW = '\033[' + str(33) + 'm'
RED = '\033[' + str(31) + 'm'
WHITE = '\033[' + str(37) + 'm'
BLACK = '\033[' + str(30) + 'm'
BOLD_MAGENTA = BOLD + MAGENTA
BOLD_CYAN = BOLD + CYAN
BOLD_BLUE = BOLD + BLUE
BOLD_GREEN = BOLD + GREEN
BOLD_YELLOW = BOLD + YELLOW
BOLD_RED = BOLD + RED
BOLD_WHITE = BOLD + WHITE
BOLD_BLACK = BOLD + BLACK


def main():
    if len(sys.argv) < 2:
        print("Benutzung:", sys.argv[0], "<Wort>")
    else:
        url = get_url(sys.argv[1])
        print_terms(get_json(url))


def get_url(input, similar=False, substring=False):
    url = "http://www.openthesaurus.de/synonyme/search?format=application/json"
    if similar:
        url = url + "&similar=true"
    if substring:
        url = url + "&substring=true"
    return url + "&q=" + quote(input, '')


def get_json(url):
    r = urlopen(url).read()
    js = json.loads(r.decode())
    return js


def print_terms(json):
    print()
    colors = [BOLD_WHITE, BOLD_YELLOW, BOLD_MAGENTA,
              BOLD_GREEN, BOLD_BLUE, BOLD_RED, BOLD_CYAN]
    counter = 0
    for s in json['synsets']:
        for i in s['terms']:
            level = ""
            if i.get('level'):
                level = " " + i.get('level')
            print(colors[counter] + " - " + i['term'] +
                  BOLD_BLACK + level + RESET)
        counter = (counter + 1) % len(colors)
        print()

if __name__ == '__main__':
    main()

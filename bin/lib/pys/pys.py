#!/usr/bin/env python3

import shutil
import sys

from plugin.search import ag
from plugin.search import ack
from plugin.search import grep
from plugin.search import pdfgrep
from plugin.view import curses

SEARCH_PLUGIN = ag
VIEW_PLUGIN = curses

def print_help():
    print("Usage: pys.py [-i] <search-term> <search-path>")

def check_arg():
    if len(sys.argv) < 3:
        print_help()
    elif sys.argv[1] == '-h' or sys.argv[1] == '--help':
        print_help()
    else:
        return True

def main():
    if check_arg():
        r = SEARCH_PLUGIN.Results()
        term = sys.argv[1]
        path = sys.argv[2]
        if sys.argv[1] == "-i":
            r.ignore_case = True
            term = sys.argv[2]
            path = sys.argv[3]
        r.search_term = term
        r.search_path = path

        view = VIEW_PLUGIN.View(r.search())
        view.show()

if __name__ == '__main__':
    main()

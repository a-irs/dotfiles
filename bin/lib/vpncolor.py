#!/usr/bin/env python3

import sys
import subprocess


class Color(object):
    RESET = '\033[' + str(0) + 'm'
    BOLD = '\033[' + str(1) + 'm'
    DIM = '\033[' + str(2) + 'm'
    MAGENTA = '\033[' + str(95) + 'm'
    CYAN = '\033[' + str(96) + 'm'
    BLUE = '\033[' + str(94) + 'm'
    GREEN = '\033[' + str(92) + 'm'
    YELLOW = '\033[' + str(93) + 'm'
    RED = '\033[' + str(91) + 'm'
    WHITE = '\033[' + str(97) + 'm'
    BLACK = '\033[' + str(90) + 'm'
    BOLD_MAGENTA = BOLD + MAGENTA
    BOLD_CYAN = BOLD + CYAN
    BOLD_BLUE = BOLD + BLUE
    BOLD_GREEN = BOLD + GREEN
    BOLD_YELLOW = BOLD + YELLOW
    BOLD_RED = BOLD + RED
    BOLD_WHITE = BOLD + WHITE
    BOLD_BLACK = BOLD + BLACK


def parse(line):
    l = bytes.decode(line).strip(' \t\n\r').split()
    datetime = Color.DIM + " ".join(l[0:5]) + Color.RESET
    rest = " ".join(l[5:])

    rest = highlight(rest, "Data Channel Encrypt:", Color.YELLOW, False, False)
    rest = highlight(rest, "Data Channel Decrypt:", Color.YELLOW, False, False)
    rest = highlight(rest, "TLS:", Color.YELLOW, False, False)
    rest = highlight(rest, "cipher", Color.YELLOW, True, True)

    rest = highlight(rest, "opened", Color.BOLD_GREEN, True, False)
    rest = highlight(rest, "Initialization Sequence Completed", Color.BOLD_GREEN, True, False)
    rest = highlight(rest, "TUN/TAP", Color.BOLD_GREEN, True, False)
    rest = highlight(rest, "tap0", Color.BOLD_GREEN, True, False)
    rest = highlight(rest, "VERIFY OK:", Color.GREEN, False, False)
    rest = highlight(rest, "Peer Connection Initiated", Color.GREEN, False, False)
    rest = highlight(rest, "PUSH:", Color.GREEN, False, False)
    rest = highlight(rest, "OPTIONS IMPORT:", Color.GREEN, False, False)

    rest = highlight(rest, "/usr/bin/ip", Color.BOLD_MAGENTA, False, False)
    rest = highlight(rest, "update-resolv-conf", Color.BOLD_MAGENTA, False, False)

    rest = highlight(rest, "library versions:", Color.DIM, True, False)
    rest = highlight(rest, "NOTE:", Color.DIM, True, False)
    rest = highlight(rest, "OpenVPN 2.", Color.DIM, True, False)

    rest = highlight(rest, "ERROR", Color.BOLD_RED, True, True)

    print(datetime + " " + rest)


def highlight(line, to_colorize, color, color_whole=False, case_insensitive=False):
    idx = -1
    if case_insensitive:
        idx = line.lower().find(to_colorize.lower())
    else:
        idx = line.find(to_colorize)

    if idx == -1:
        return line

    if color_whole:
        return color + line[0:idx] + line[idx:idx+len(to_colorize)] + line[idx+len(to_colorize):] + Color.RESET
    else:
        return line[0:idx] + color + line[idx:idx+len(to_colorize)] + Color.RESET + line[idx+len(to_colorize):]


proc = subprocess.Popen(sys.argv[1:], stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout
for line in proc:
    parse(line)

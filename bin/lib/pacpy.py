#!/usr/bin/env python3

import sys
from datetime import datetime
from glob import glob
import getopt


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


class Config(object):
    SHOW_GROUPS = True
    SHOW_TIME = True
    SHOW_VERSION = False
    SHOW_SIZE = False
    SORT_SIZE = False
    REVERSE = False
    FORMAT_DATE = "%Y-%m-%d"
    FORMAT_TIME = "%H:%M"
    AUR_COLOR = Color.YELLOW
    PKG_COLOR = Color.GREEN
    TIME_COLOR = Color.DIM
    DATE_COLOR = Color.BOLD


class Package(object):
    path = ""
    name = ""
    size = 0
    version = ""
    install_date = 0
    is_explicit = True
    is_aur = False

    def __init__(self, path):
        """creates a package object from given path,
        e.g. /var/lib/pacman/local/aspell-0.60.6.1-1/desc"""
        f = open(path, 'r')
        searchlines = f.readlines()
        f.close()

        self.path = path
        for i, line in enumerate(searchlines):
            if "%NAME%" in line:
                self.name = searchlines[i:i+2][1].strip()
            elif "%VERSION" in line:
                self.version = searchlines[i:i+2][1].strip()
            elif "%SIZE" in line:
                self.size = int(searchlines[i:i+2][1].strip())
            elif "%INSTALLDATE%" in line:
                self.install_date = int(searchlines[i:i+2][1].strip())
            elif "%VALIDATION%" in line:
                self.is_aur = searchlines[i:i+2][1].strip() == "none"
            elif "%REASON%" in line:
                reason = int(searchlines[i:i+2][1].strip())
                if reason == 1:
                    self.is_explicit = False


def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "eadruvsS")
    except getopt.GetoptError as _:
        print_usage()
        sys.exit(2)

    explicit_only = False
    dependencies_only = False
    aur_only = False
    for o, _ in opts:
        if o == "-e":
            explicit_only = True
        elif o == "-a":
            aur_only = True
        elif o == "-d":
            dependencies_only = True
        elif o == "-r":
            Config.REVERSE = True
        elif o == "-u":
            Config.SHOW_GROUPS = False
        elif o == "-v":
            Config.SHOW_VERSION = True
        elif o == "-s":
            Config.SHOW_SIZE = True
        elif o == "-S":
            Config.SORT_SIZE = True
            Config.SHOW_GROUPS = False
            Config.SHOW_SIZE = True

    if explicit_only and dependencies_only:
        print("\n-e and -d cannot be used together")
        sys.exit(2)

    files = glob('/var/lib/pacman/local/*/desc')
    result = [Package(p) for p in files]

    if Config.SORT_SIZE:
        result.sort(key=lambda p: p.size, reverse=Config.REVERSE)
    else:
        result.sort(key=lambda p: p.install_date, reverse=Config.REVERSE)

    last_date = None
    for p in result:
        if p.is_explicit or not explicit_only:
            if not p.is_explicit or not dependencies_only:
                if p.is_aur or not aur_only:
                    if Config.SHOW_GROUPS:
                        date = pretty_date(p, Config.FORMAT_DATE)
                        if last_date != date:
                            print("\n" + date + "\n")
                            last_date = date
                    print(package_info(p))


def print_usage():
    """prints usage information"""
    print(sys.argv[0].split("/")[-1] + " [-e] [-d] [-a] [-r] [-v] [-s] [-S]\n")
    print("   -e: only list explicitly installed packages")
    print("   -d: only list packages that were installed as a dependency")
    print("   -a: only list packages from AUR")
    print("   -r: reverse sort order")
    print("   -v: show version of packages")
    print("   -s: show size of packages")
    print("   -S: sort by size")


def package_info(p):
    """return package information"""
    prefix = ""
    fmt = Config.FORMAT_TIME

    if Config.SHOW_GROUPS:
        prefix = "  "
    else:
        fmt = Config.FORMAT_DATE + " " + Config.FORMAT_TIME

    if Config.SHOW_TIME:
        return prefix + pretty_time(p, fmt) + " " + pretty_name(p)
    else:
        return prefix + pretty_name(p)


def pretty_name(p):
    """returns pretty name of the package: Color as set in the config.
    Bold if package was installed explicitly"""
    color = Config.AUR_COLOR if p.is_aur else Config.PKG_COLOR
    color = Color.BOLD + color if p.is_explicit else color

    s = color + p.name
    if Config.SHOW_SIZE:
        s = s + " (" + pretty_size(p.size) + ")"
    if Config.SHOW_VERSION:
        s = s + " (" + p.version + ")"
    return s + Color.RESET


def pretty_size(i):
    if i < 1024*1024:
        return "{:.2f}".format(i / 1024) + " KiB"
    return "{:.2f}".format(i / 1024 / 1024) + " MiB"


def pretty_date(p, format):
    """returns pretty date of the package that was given as seconds"""
    date = datetime.fromtimestamp(p.install_date)
    return Color.BOLD + date.strftime(format) + Color.RESET


def pretty_time(p, format):
    """returns pretty time of the package that was given as seconds"""
    time = datetime.fromtimestamp(p.install_date)
    return Config.TIME_COLOR + time.strftime(format)

if __name__ == '__main__':
    main()

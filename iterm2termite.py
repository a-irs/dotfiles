#!/usr/bin/env python2

import plistlib

FILE = "com.googlecode.iterm2.plist"
SCHEME = "colorscheme2"


# rgb_to_hex by http://stackoverflow.com/a/214657
def rgb_to_hex(rgb):
    return '#%02x%02x%02x' % rgb


def iterm_to_rgb(clr):
    rkey = 'Red Component'
    bkey = 'Blue Component'
    gkey = 'Green Component'
    return round(clr[rkey] * 255), round(clr[gkey] * 255), round(clr[bkey] * 255)


def format_termite(bg, fg, fgbold, csr, pallete):
    conf = "background = {}\n".format(bg)
    conf += "foreground = {}\n".format(fg)
    conf += "foreground_bold = {}\n".format(fgbold)
    conf += "cursor = {}\n".format(csr)
    for i, k in enumerate(pallete):
        conf += "color{} = {}\n".format(i, k)
    return conf


def get_item(item):
    plist = plistlib.readPlist(FILE)
    return plist['Custom Color Presets'][SCHEME][item]


def to_termite():
    bg_hex = rgb_to_hex(iterm_to_rgb(get_item('Background Color')))
    fg_hex = rgb_to_hex(iterm_to_rgb(get_item('Foreground Color')))
    fgbold_hex = rgb_to_hex(iterm_to_rgb(get_item('Bold Color')))
    csr_hex = rgb_to_hex(iterm_to_rgb(get_item('Cursor Color')))

    pallete_hex = []
    for index in range(0, 16):
        color_key = "Ansi {0} Color".format(index)
        color_rgb = iterm_to_rgb(get_item(color_key))
        color_hex = rgb_to_hex(color_rgb)
        pallete_hex.append(color_hex)

    return format_termite(bg_hex, fg_hex, fgbold_hex, csr_hex, pallete_hex)


if __name__ == "__main__":
    print(to_termite())

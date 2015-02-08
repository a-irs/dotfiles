#!/usr/bin/env python

import sys
import configparser
import codecs
import ntpath
import os
import markdown
import cssmin
from os.path import expanduser

###############################################################################

def get_config(name, section="md", filename="md.conf"):
    script_root = os.path.dirname(os.path.realpath(__file__))
    config = configparser.ConfigParser()
    config.read(os.path.join(script_root, filename))
    return config[section][name]

###############################################################################

def read_tpl(filename):
    script_root = os.path.dirname(os.path.realpath(__file__))

    if (filename == 'style.css') or (filename == 'highlight.css'):
        path = os.path.join(script_root, 'template', get_config('theme'), filename)
    else:
        path = os.path.join(script_root, 'template', filename)
    with codecs.open(path, 'r', 'utf-8') as f:
        return f.read()

###############################################################################

def markdown_convert(main_template, filename, highlight=True):
    output_filename = ntpath.splitext(filename)[0] + ".html"

    # get markdown file contents
    with codecs.open(filename, 'r', 'utf-8') as f:
        md_content = f.read()

    # convert markdown to html
    markdown_html = markdown.markdown(md_content, extensions=['extra', 'toc'])

    # fill main_template with contents
    html = main_template.replace('[CONTENT]', markdown_html)
    html = html.replace('[TITLE]', ntpath.basename(ntpath.splitext(filename)[0]).title())
    html = html.replace('[CSS_STYLE]', TPL_STYLE_CSS)
    html = html.replace('[CSS_SYNTAX]', TPL_HIGHLIGHT_CSS)
    if highlight:
        html = html.replace('[HIGHLIGHT_JS]', TPL_HIGHLIGHT_JS)

    # write changed files
    with open(output_filename, 'w', encoding='utf-8') as f:
        f.write(html)
        print(output_filename.replace(expanduser("~"), "~"))

###############################################################################

def get_files(pathlist, extension=".md"):

    # append files to list
    flist = []
    for path in pathlist:
        if os.path.isdir(path):
            for root, dirs, files in os.walk(path):
                for f in files:
                    if f.endswith(extension):
                        flist.append(os.path.join(root, f))
        elif os.path.isfile(path):
            flist.append(path)
    flist = sorted(flist, key=str.lower)

    # remove duplicates while preserving order
    seen = set()
    seen_add = seen.add
    return [ x for x in flist if x not in seen and not seen_add(x) ]

###############################################################################

TPL_MAIN = read_tpl('template.html')
TPL_STYLE_CSS = cssmin.cssmin(read_tpl('style.css'))
TPL_HIGHLIGHT_CSS = cssmin.cssmin(read_tpl('highlight.css'))
TPL_HIGHLIGHT_JS = read_tpl('highlight.js')

if len(sys.argv) < 2:
    print('ERROR! Proper usage: ' + __file__ + ' [FILE/DIR] [FILE/DIR] [FILE/DIR] ...')
else:
    print()
    for f in get_files(sys.argv[1:]):
        markdown_convert(TPL_MAIN, f)


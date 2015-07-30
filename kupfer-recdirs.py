
# Copyright (C) 2012 Christopher Pramerdorfer

#   This software is provided 'as-is', without any express or implied
#   warranty.  In no event will the authors be held liable for any damages
#   arising from the use of this software.

#   Permission is granted to anyone to use this software for any purpose,
#   including commercial applications, and to alter it and redistribute it
#   freely, subject to the following restrictions:

#   1. The origin of this software must not be misrepresented; you must not
#      claim that you wrote the original software. If you use this software
#      in a product, an acknowledgment in the product documentation would be
#      appreciated but is not required.
#   2. Altered source versions must be plainly marked as such, and must not be
#      misrepresented as being the original software.
#   3. This notice may not be removed or altered from any source distribution.

import os
from kupfer.objects import Source
from kupfer.obj.objects import ConstructFileLeaf
from kupfer import plugin_support

__kupfer_name__ = _("Recursive Directories")
__kupfer_sources__ = ("RecursiveDirectorySource", )
__kupfer_text_sources__ = ()
__kupfer_actions__ = ()
__description__ = _("Provides recursive directory access")
__version__ = "0.1"
__author__ = "Christopher Pramerdorfer"

__kupfer_settings__ = plugin_support.PluginSettings(
    {
        'key': 'dirs',
        'label': _('Directories'),
        'type': str,
        'value': '~/Documents;3;~/Videos;2',
    },
    {
        'key': 'blacklist',
        'label': _('Blacklist'),
        'type': str,
        'value': '.git;.svn',
    }
)

def get_immediate_subdirectories(dir, blacklist):
    return [os.path.join(dir, name) for name in os.listdir(dir) if os.path.isdir(os.path.join(dir, name)) and name not in blacklist]

def get_recursive_subdirectories(dir, blacklist, rcur, rmax, sink):
    subdirs = get_immediate_subdirectories(dir, blacklist)
    sink.update(subdirs)

    if rcur < rmax:
        for subdir in subdirs:
            get_recursive_subdirectories(subdir, blacklist, rcur + 1, rmax, sink)

class RecursiveDirectorySource (Source):
    def __init__(self):
        Source.__init__(self, _("Recursive Directories"))

    def initialized(self):
        __kupfer_settings__.connect("plugin-setting-changed", self._changed)

    def get_items(self):
        return (ConstructFileLeaf(d) for d in self._get_dirs())

    def get_icon_name(self):
        return "folder"

    def get_description(self):
        return _("Recursive subdirectory access")

    def _get_dirs(self):
        dirinfo = self._get_root_dirs()
        blacklist = self._get_blacklist()
        directories = set()

        for dir, levels in dirinfo.iteritems():
            directories.add(dir)
            get_recursive_subdirectories(dir, blacklist, 1, levels, directories)

        return directories

    def _get_root_dirs(self):
        if not __kupfer_settings__['dirs']:
            return []

        dirs = [os.path.expanduser(d) for d in __kupfer_settings__['dirs'].split(';')[0::2]]
        levels = [max(1, int(l)) for l in __kupfer_settings__['dirs'].split(';')[1::2]]

        if len(dirs) != len(levels):
            raise ValueError('Must define number of recursion levels for every root directory.')

        info = dict(zip(dirs, levels))
        for d in dirs:
            if not os.path.isdir(d):
                del info[d]

        return info

    def _get_blacklist(self):
        if not __kupfer_settings__['blacklist']:
            return []
        return __kupfer_settings__['blacklist'].split(';')

    def _changed(self, settings, key, value):
        if key in ('dirs', 'blacklist'):
            self.mark_for_update()

local naughty = require 'naughty'
local awful   = require 'awful'
local get_dpi = require('beautiful').xresources.get_dpi

os.execute('xrdb -merge ' .. os.getenv("HOME") .. '/.Xresources')

hostname = io.popen("uname -n"):read()
local v = tonumber(io.popen("xrandr | grep \\* | awk '{print $1}' | cut -dx -f 2"):read())
vres = v * 96 / get_dpi()
compact_display = vres < 1000

function is_empty(tag)
    return #tag:clients() == 0
end

user_terminal    = "terminator"
user_browser     = "firefox"
user_editor      = "subl3"
user_filemanager = "thunar"

require 'awm-beautiful'
require 'awm-notify-settings'

function dbg(text)
    naughty.notify({ text = text, timeout = 0 })
end

function dbg_crit(text)
    naughty.notify({ preset = naughty.config.presets.critical, text = text, timeout = 0 })
end

require 'awm-error-handling'
require 'awm-autostart'
require 'awm-layouts'
require 'awm-tags'
require 'awm-bindings'
require 'awm-statusbar'
require 'awm-rules'

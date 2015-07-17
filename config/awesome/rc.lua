local naughty    = require 'naughty'
local awful      = require 'awful'
local xresources = require('beautiful').xresources

os.execute('xrdb -merge ' .. os.getenv("HOME") .. '/.Xresources')

user_terminal   = "terminator"
hostname        = io.popen("uname -n"):read()

vres            = tonumber(io.popen("xrandr | grep \\* | awk '{print $1}' | cut -dx -f 2"):read()) * 96 / xresources.get_dpi()
compact_display = vres < 1000
high_dpi        = xresources.get_dpi() >= 168

function dpi(value)
    return math.ceil(xresources.apply_dpi(value))
end

function is_empty(tag)
    return #tag:clients() == 0
end

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

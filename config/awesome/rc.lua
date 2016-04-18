local naughty    = require 'naughty'
local awful      = require 'awful'
local lain       = require 'lain'
local xresources = require('beautiful').xresources
local beautiful  = require 'beautiful'

-- revert "Only use useless_gap with multiple tiled clients"
local getgap = awful.tag.getgap
function awful.tag.getgap(t, numclients)
    return getgap(t, 42)
end

os.execute('xrdb -merge ' .. os.getenv("HOME") .. '/.Xresources')

user_terminal   = "termite"
hostname        = io.popen("uname -n"):read()

vres            = tonumber(io.popen("xrandr | grep \\* | awk '{print $1}' | cut -dx -f 2"):read()) * 96 / xresources.get_dpi()
hres            = tonumber(io.popen("xrandr | grep \\* | awk '{print $1}' | cut -dx -f 1 | xargs echo"):read()) * 96 / xresources.get_dpi()
compact_display = true -- or vres < 1000
high_dpi        = xresources.get_dpi() >= 168

function dpi(value)
    return math.floor(xresources.apply_dpi(value) + 0.5)
end

function is_empty(tag)
    return #tag:clients() == 0
end

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

require 'awm-notify-settings'

function dbg(text)
    naughty.notify({ text = text, timeout = 0 })
end

function dbg_crit(text)
    naughty.notify({ preset = naughty.config.presets.critical, text = text, timeout = 0 })
end

--- battery critical notification
local function trim(s)
    return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end
local function bat_notification()
    local f_capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
    local f_status = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))
    local bat_capacity = tonumber(f_capacity:read("*all"))
    local bat_status = trim(f_status:read("*all"))
    if (bat_capacity <= 15 and bat_status == "Discharging") then
        naughty.notify({
            preset = naughty.config.presets.critical,
            text = lain.util.markup.bold("Critical battery!")
        })
    end
end
if hostname == "dell" then
    battimer = timer({ timeout = 60 })
    battimer:connect_signal("timeout", bat_notification)
    battimer:start()
end

require 'awm-error-handling'
require 'awm-layouts'
require 'awm-tags'
require 'awm-bindings'
require 'awm-statusbar'
require 'awm-rules'

pcall(require, "luarocks.loader")

local naughty    = require 'naughty'
local awful      = require 'awful'
local gears      = require 'gears'
local lain       = require 'lain'
local xresources = require('beautiful').xresources
local beautiful  = require 'beautiful'

awful.spawn("nitrogen --restore", false)

hostname        = awesome.hostname
is_mobile       = hostname == "dell" or hostname == "x1"
is_high_dpi     = xresources.get_dpi() >= 100

function dpi(value)
    return math.floor(xresources.apply_dpi(value) + 0.5)
end

beautiful.init(gears.filesystem.get_configuration_dir () .. "theme.lua")

require 'awm-notify-settings'

-- error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "An error happened!",
                         text = err })
        in_error = false
    end)
end


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
if is_mobile then
    battimer = timer({ timeout = 60 })
    battimer:connect_signal("timeout", bat_notification)
    battimer:start()
end

require 'awm-layouts'
require 'awm-tags'
require 'awm-bindings'
require 'awm-statusbar'
require 'awm-rules'

-- toggle tag1, tag2 on startup (to make initial win+tab possible)
local tag = awful.tag.gettags(awful.screen.focused())[1]
local tag2 = awful.tag.gettags(awful.screen.focused())[2]
if tag2 then awful.tag.viewonly(tag2) end
if tag then awful.tag.viewonly(tag) end

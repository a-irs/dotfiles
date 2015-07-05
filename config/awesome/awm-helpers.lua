local naughty = require 'naughty'

hostname = io.popen("uname -n"):read()
vertical_resolution = tonumber(io.popen("xrandr | grep \\* | awk '{print $1}' | cut -dx -f 2"):read())
compact_display = vertical_resolution < 1000

function dbg(text)
    naughty.notify({ text = text, timeout = 0 })
end

function dbg_crit(text)
    naughty.notify({ preset = naughty.config.presets.critical, text = text, timeout = 0 })
end

function is_empty(tag)
    return #tag:clients() == 0 and not tag.selected
end

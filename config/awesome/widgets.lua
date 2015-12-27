local awful   = require 'awful'
local wibox   = require 'wibox'
local lain    = require 'lain'
local alsa    = require 'alsa'
local volume  = require 'volume'
local vicious = require 'vicious'
local widgets = {}

markup = lain.util.markup

local function get_genmon(script)
    local command = os.getenv("HOME") .. "/.bin/lib/genmon/" .. script .. " awesome"
    local fh = assert(io.popen(command, "r"))
    local text = fh:read("*l")
    fh:close()
    return text
end

local function make_genmon(script, timeout)
    local new_widget = wibox.widget.textbox()
    new_widget:set_markup(get_genmon(script))
    local new_widget_timer = timer({ timeout = timeout })
    new_widget_timer:connect_signal("timeout",
        function() new_widget:set_markup(get_genmon(script)) end
    )
    new_widget_timer:start()
    return new_widget
end



function widgets.make_widget(widget, background_color, left, right)
    if left and right then
        local m = wibox.layout.margin(widget, left, right, 0, 0)
        local b = wibox.widget.background(m)
        b:set_bg(background_color)
        return b
    end
    local b = wibox.widget.background(widget)
    b:set_bg(background_color)
    return b
end


-- BATTERY

if hostname == "dell" then widgets.batterywidget = make_genmon("battery.sh", 5) end


-- NETWORK

if hostname == "dell" then widgets.netwidget = make_genmon("net.sh", 5) end


-- VOLUME

widgets.volumewidget = alsa({
    timeout = 3,
    settings = function()
        if volume_now.status == "off" then
            widget:set_markup(markup.bold(markup(theme.widget_alsa_mute_fg, volume_now.level)))
        else
            widget:set_markup(markup.bold(markup(theme.widget_alsa_fg, volume_now.level)))
        end
    end
})
widgets.volumewidget.widget:buttons(awful.util.table.join(
       awful.button({ }, 4, function() volume.increase() end), -- wheel up
       awful.button({ }, 5, function() volume.decrease() end), -- wheel down
       awful.button({ }, 1, function() volume.toggle()   end), -- left click
       awful.button({ }, 3, function() volume.toggle()   end)  -- right click
))


-- DATE, TIME

widgets.datewidget = lain.widgets.base({
    timeout  = 2,
    cmd      = "date +'%a, %d.%m. %H:%M'",
    settings = function()
        local t_output = ""
        local o_it = string.gmatch(output, "%S+")
        widget:set_markup(markup(theme.widget_date_fg, o_it(1) .. " " .. o_it(1)) .. " " .. markup.bold(markup(theme.widget_time_fg, o_it(1))))
    end
})
lain.widgets.calendar:attach(widgets.datewidget, { font_size = theme.widget_calendar_font_size,
                                           font = theme.widget_calendar_font,
                                           fg = theme.widget_calendar_fg,
                                           bg = "#222a34",
})


-- MPD

widgets.mpdwidget = wibox.widget.textbox()
widgets.mpdwidget:set_font(theme.font)

vicious.register(widgets.mpdwidget, vicious.widgets.mpd,
    function(mpdwidget, args)
        if args["{state}"] == "Play" then
            return markup(theme.widget_mpd_fg, markup.bold(args["{Artist}"]) .. ' - ' .. args["{Title}"])
        else
            return "          "
        end
    end, 2)
widgets.mpdwidget:buttons(awful.util.table.join(
                      awful.button({ }, 1, function() awful.util.spawn("ario") end)
))


-- CPU

widgets.cpuwidget = lain.widgets.cpu({
    timeout = 2,
    settings = function()
        widget:set_markup(markup(theme.widget_cpu_fg, "CPU: " .. markup.bold(markup.bold(cpu_now.usage .. "%     "))))
    end
})


--- CPU FREQ

widgets.cpufreq1widget = wibox.widget.textbox()
vicious.register(widgets.cpufreq1widget, vicious.widgets.cpufreq, markup(theme.widget_cpu_freq_fg, "CPU0: " .. markup.bold("$2 Ghz   ")), 2, "cpu0")
widgets.cpufreq2widget = wibox.widget.textbox()
vicious.register(widgets.cpufreq2widget, vicious.widgets.cpufreq, markup(theme.widget_cpu_freq_fg, "CPU1: " .. markup.bold("$2 GHz     ")), 2, "cpu1")


-- MEM

widgets.memwidget = wibox.widget.textbox()
vicious.register(widgets.memwidget, vicious.widgets.mem, markup(theme.widget_mem_fg, "RAM: " .. markup.bold("$1%     ")), 5)


-- LOAD

widgets.loadwidget = lain.widgets.sysload({
    timeout = 2,
    settings  = function()
        widget:set_markup(markup(theme.widget_load_fg, "Load: " .. markup.bold(load_1 .. " " .. load_5 .. " " .. load_15 .. "     ")))
    end
})


-- DISK I/O

widgets.iowidget = wibox.widget.textbox()
vicious.register(widgets.iowidget, vicious.widgets.dio,
       markup(theme.widget_disk_read_fg, "read: " .. markup.bold("${sda read_mb} MB/s "))
    .. markup(theme.widget_disk_write_fg, " write: " .. markup.bold("${sda write_mb} MB/s    ")), 2)


-- NETWORK SPEED

widgets.speedwidget = lain.widgets.net({
    notify = "off",
    settings = function()
        down_speed = math.floor(tonumber(net_now.received))
        up_speed   = math.floor(tonumber(net_now.sent))
        widget:set_markup(
            markup(theme.widget_speed_down, " ↓ DL: " .. markup.bold(down_speed))
            .. " " ..
            markup(theme.widget_speed_up, " ↑ UL: " .. markup.bold(up_speed) .. "     "))
    end
})


-- CPU GRAPH

widgets.cpugraphwidget = awful.widget.graph()
widgets.cpugraphwidget:set_width(80)
widgets.cpugraphwidget:set_background_color(theme.widget_cpu_graph_bg)
widgets.cpugraphwidget:set_color(theme.widget_cpu_graph_fg)
vicious.register(widgets.cpugraphwidget, vicious.widgets.cpu, "$1")

return widgets

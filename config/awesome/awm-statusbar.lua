local awful   = require 'awful'
local rules   = require 'awful.rules'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local volume  = require 'volume'
local vicious = require 'vicious'

markup = lain.util.markup


local function make_widget(widget, left_margin, right_margin, background_color)
    if left_margin and not right_margin then
        right_margin = left_margin
    end

    if right_margin or left_margin then
        widget = wibox.layout.margin(widget, left_margin, right_margin, 0, 0)
    end

    if background_color then
        widget = wibox.widget.background(widget)
        widget:set_bg(background_color)
    end

    return widget
end


local function lay(layout, widget, left, right, background_color)
    if widget then
        layout:add(make_widget(widget, left, right, background_color))
    end
end


-- BATTERY

if hostname == "dell" then
    batterywidget = lain.widgets.bat({
        timeout = 3,
        notify = "off",
        settings = function()
            p = tonumber(bat_now.perc)
            if p > 100 then
                p = 100
            end
            if p <= 15 then
                color = "#db3131"
            elseif p <= 40 then
                color = "#ffff00"
            elseif p <= 70 then
                color = "#ffffff"
            else
                color = "#90ee90"
            end

            charg = ''
            if bat_now.status == "Full" or bat_now.status == "Charging" then
                charg = markup("#ffff00", ' +')
            end
            widget:set_markup(markup.bold(markup(color, p .. charg)))
        end
    })
end


-- NETWORK

if hostname == "dell" then
    netwidget = lain.widgets.base({
        timeout = 3,
        cmd = os.getenv("HOME") .. "/.config/awesome/network-info.sh",
        settings = function()
            widget:set_markup(output)
        end
    })
end


-- SPOTIFY

spotifywidget = lain.widgets.base({
    timeout = 2,
    cmd = os.getenv("HOME") .. "/.config/awesome/spotify-info.sh " .. theme.widget_spotify_fg:gsub('#', ''),
    settings = function()
        if output == "" then
            widget:set_markup("")
        else
            widget:set_markup(output)
        end
    end
})
spotifywidget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function() -- right click
        local matcher = function(c)
            return rules.match(c, {class = 'Spotify'})
        end
        awful.client.run_or_raise('spotify', matcher)
    end)
))

-- VOLUME

pulsewidget = lain.widgets.pulseaudio({
    timeout = 3,
    settings = function()
        if volume_now.left == nil or volume_now.right == nil then
            widget:set_markup("ERROR")
            return
        end
        local level = math.floor((volume_now.left + volume_now.right) / 2 / 5 + 0.5) * 5
        if volume_now.muted =="yes" then
            widget:set_markup(markup.bold(markup(theme.widget_pulse_mute_fg, level)))
        else
            widget:set_markup(markup.bold(markup(theme.widget_pulse_fg, level)))
        end
    end
})
pulsewidget.widget:buttons(awful.util.table.join(
    awful.button({ }, 4, function() volume.increase() end), -- wheel up
    awful.button({ }, 5, function() volume.decrease() end), -- wheel down
    awful.button({ }, 1, function() volume.toggle()   end), -- left click
    awful.button({ }, 3, function() -- right click
        local matcher = function(c)
            return rules.match(c, {class = 'Pavucontrol'})
        end
        awful.client.run_or_raise('pavucontrol', matcher)
    end)
))


-- DATE, TIME

timewidget = awful.widget.textclock(markup.bold(markup(theme.widget_time_fg, '%H:%M')))
datewidget = awful.widget.textclock(markup(theme.widget_date_fg, '%a, %d.%m.'))
lain.widgets.calendar:attach(datewidget, {
    font_size = "8",
    font = "Monospace",
    fg   = theme.fg_focus,
    bg   = theme.bg_focus
})
lain.widgets.calendar:attach(timewidget, {
    font_size = "8",
    font = "Monospace",
    fg   = theme.fg_focus,
    bg   = theme.bg_focus
})


-- MPD

--[[
mpdwidget = wibox.widget.textbox()
mpdwidget:set_font(theme.font)

vicious.register(mpdwidget, vicious.widgets.mpd,
    function(mpdwidget, args)
        if args["{state}"] == "Play" then
            return " " .. markup(theme.widget_mpd_fg, markup.bold("♫ " .. args["{Title}"]) .. ' (' .. args["{Artist}"] .. ") ")
        else
            return ""
        end
    end, 2)
mpdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function() awful.util.spawn("ario") end)
))
--]]

-- CPU

cpuwidget = lain.widgets.cpu({
    timeout = 2,
    settings = function()
        widget:set_markup(markup(theme.widget_cpu_fg, "CPU: " .. markup.bold(markup.bold(cpu_now.usage .. "%     "))))
    end
})


--- CPU FREQ

cpufreq1widget = wibox.widget.textbox()
vicious.register(cpufreq1widget, vicious.widgets.cpufreq, markup(theme.widget_cpu_freq_fg, "CPU0: " .. markup.bold("$2 Ghz   ")), 2, "cpu0")
cpufreq2widget = wibox.widget.textbox()
vicious.register(cpufreq2widget, vicious.widgets.cpufreq, markup(theme.widget_cpu_freq_fg, "CPU1: " .. markup.bold("$2 GHz     ")), 2, "cpu1")


-- MEM

memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, markup(theme.widget_mem_fg, "RAM: " .. markup.bold("$1%     ")), 5)


-- LOAD

loadwidget = lain.widgets.sysload({
    timeout = 2,
    settings  = function()
        widget:set_markup(markup(theme.widget_load_fg, "Load: " .. markup.bold(load_1 .. " " .. load_5 .. " " .. load_15 .. "     ")))
    end
})


-- DISK I/O

iowidget = wibox.widget.textbox()
vicious.register(iowidget, vicious.widgets.dio,
       markup(theme.widget_disk_read_fg, "read: " .. markup.bold("${sda read_mb} MB/s "))
    .. markup(theme.widget_disk_write_fg, " write: " .. markup.bold("${sda write_mb} MB/s    ")), 2)


-- NETWORK SPEED

speedwidget = lain.widgets.net({
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

cpugraphwidget = awful.widget.graph()
cpugraphwidget:set_width(80)
cpugraphwidget:set_background_color(theme.widget_cpu_graph_bg)
cpugraphwidget:set_color(theme.widget_cpu_graph_fg)
vicious.register(cpugraphwidget, vicious.widgets.cpu, "$1")

mywibox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ }, 3, awful.tag.viewtoggle)
                    )
systembox = {}
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            if not c:isvisible() then
                awful.tag.viewonly(c.first_tag)
            end
        client.focus = c
        c:raise()
        end
    end))
myprompt = {}

awful.screen.connect_for_each_screen(function(s)
    mytaglist[s]  = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s]    = awful.wibox({ position = theme.statusbar_position, screen = s, height = theme.statusbar_height })
    myprompt[s]   = awful.widget.prompt()
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.minimizedcurrenttags, mytasklist.buttons, { fg_normal = theme.tasklist_fg, bg_normal = theme.tasklist_bg, font = theme.tasklist_font })
    --[[
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                       awful.button({ }, 1, function() awful.layout.inc(layouts,  1) end),
                       awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
                       awful.button({ }, 4, function() awful.layout.inc(layouts,  1) end),
                       awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))
    mylayoutbox[s]:connect_signal("mouse::enter", function() systembox[awful.screen.focused()].visible = true end)
    mylayoutbox[s]:connect_signal("mouse::leave", function() systembox[awful.screen.focused()].visible = false end)
    ]]--

    -- layouts

    local m = 3

    local layout1 = wibox.layout.fixed.horizontal()
    lay(layout1, mylayoutbox[s])
    lay(layout1, mpdwidget, 0, 0, theme.bg_focus)
    lay(layout1, spotifywidget, 0, 0, theme.bg_focus)
    lay(layout1, mytasklist[s])
    lay(layout1, myprompt[s], 0, 0, theme.bg_focus)

    local layout2 = wibox.layout.fixed.horizontal()
    lay(layout2, mytaglist[s])

    local layout3 = wibox.layout.fixed.horizontal()
    lay(layout3, pulsewidget, m)
    lay(layout3, netwidget, m)
    lay(layout3, batterywidget, m)
    lay(layout3, datewidget, m, 2)
    lay(layout3, timewidget, m, m * 2)

    -- build status bar

    local layout = wibox.layout.align.horizontal()
    layout:set_expand("none")
    layout:set_left(layout1)
    layout:set_middle(layout2)
    layout:set_right(layout3)

    mywibox[s]:set_widget(layout)

    -- SYSTEM BOX

    local systembox_position = "bottom"
    if theme.statusbar_position == "bottom" then systembox_position = "top" end
    systembox[s] = awful.wibox({ position = systembox_position, screen = s, height = theme.statusbar_height })

    local systembox_layout_1 = wibox.layout.fixed.horizontal()
    lay(systembox_layout_1, speedwidget)
    lay(systembox_layout_1, iowidget)
    lay(systembox_layout_1, memwidget)

    local systembox_layout_2 = wibox.layout.fixed.horizontal()
    lay(systembox_layout_2, loadwidget)
    lay(systembox_layout_2, cpufreq1widget)
    lay(systembox_layout_2, cpufreq2widget)
    lay(systembox_layout_2, cpuwidget)
    lay(systembox_layout_2, cpugraphwidget)
    lay(systembox_layout_2, wibox.widget.systray())

    local systembox_align_left = wibox.layout.align.horizontal()
    systembox_align_left:set_left(systembox_layout_1)
    local systembox_align_right = wibox.layout.align.horizontal()
    systembox_align_right:set_right(systembox_layout_2)

    local systembox_layout_full = wibox.layout.flex.horizontal()
    systembox_layout_full:add(systembox_align_left)
    systembox_layout_full:add(systembox_align_right)
    systembox[s]:set_widget(systembox_layout_full)
    systembox[s].visible = false
end)

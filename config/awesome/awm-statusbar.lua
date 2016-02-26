local awful   = require 'awful'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local widgets = require 'widgets'

local function lay(layout, widget, left, right, background_color)
    if widget then
        layout:add(widgets.make_widget(widget, left, right, background_color))
    end
end

pulsewidget = widgets.pulsewidget
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

for s = 1, screen.count() do
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
    mylayoutbox[s]:connect_signal("mouse::enter", function() systembox[mouse.screen].visible = true end)
    mylayoutbox[s]:connect_signal("mouse::leave", function() systembox[mouse.screen].visible = false end)
    --]]

    -- layouts

    local m = 3

    local layout1 = wibox.layout.fixed.horizontal()
    lay(layout1, widgets.mpdwidget, 0, 0, theme.bg_focus)
    lay(layout1, myprompt[s])
    lay(layout1, mylayoutbox[s])
    lay(layout1, mytasklist[s])

    local layout2 = wibox.layout.fixed.horizontal()
    lay(layout2, mytaglist[s])

    local layout3 = wibox.layout.fixed.horizontal()
    -- lay(layout3, widgets.dropboxwidget, nil, 4, 4)
    lay(layout3, pulsewidget, m)
    lay(layout3, widgets.netwidget, m)
    lay(layout3, widgets.batterywidget, m)
    lay(layout3, widgets.datewidget, m, m * 2)

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
    lay(systembox_layout_1, widgets.speedwidget)
    lay(systembox_layout_1, widgets.iowidget)
    lay(systembox_layout_1, widgets.memwidget)

    local systembox_layout_2 = wibox.layout.fixed.horizontal()
    lay(systembox_layout_2, widgets.loadwidget)
    lay(systembox_layout_2, widgets.cpufreq1widget)
    lay(systembox_layout_2, widgets.cpufreq2widget)
    lay(systembox_layout_2, widgets.cpuwidget)
    lay(systembox_layout_2, widgets.cpugraphwidget)
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
end

local awful   = require 'awful'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local widgets = require 'widgets'

local function lay(layout, widget, background_color, left, right)
    if widget then
        layout:add(widgets.make_widget(widget, background_color, left, right))
    end
end

mywibox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ }, 3, awful.tag.viewtoggle)
                    )
systembox = {}
mytasklist = {}

for s = 1, screen.count() do
    -- mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, false, { fg_focus = theme.tasklist_fg, bg_focus = theme.tasklist_bg, font = theme.tasklist_font })
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s] = awful.wibox({ position = theme.statusbar_position, screen = s, height = theme.statusbar_height })
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                       awful.button({ }, 1, function() awful.layout.inc(layouts,  1) end),
                       awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
                       awful.button({ }, 4, function() awful.layout.inc(layouts,  1) end),
                       awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))
    mylayoutbox[s]:connect_signal("mouse::enter", function() systembox[mouse.screen].visible = true end)
    mylayoutbox[s]:connect_signal("mouse::leave", function() systembox[mouse.screen].visible = false end)

    -- layouts

    local layout1 = wibox.layout.fixed.horizontal()
    lay(layout1, mylayoutbox[s])
    lay(layout1, mytasklist[s])
    lay(layout1, widgets.mpdwidget, theme.bg_normal, 0, 6)

    local layout2 = wibox.layout.fixed.horizontal()
    lay(layout2, mytaglist[s])

    local layout3 = wibox.layout.fixed.horizontal()
    lay(layout3, widgets.dropboxwidget, theme.bg_normal, 0, 8)
    lay(layout3, widgets.volumewidget,  theme.bg_normal, 0, 8)
    lay(layout3, widgets.batterywidget, theme.bg_normal, 0, 8)
    lay(layout3, widgets.datewidget,    theme.bg_focus,  8, 8)

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
    lay(systembox_layout_1, widgets.netwidget)
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

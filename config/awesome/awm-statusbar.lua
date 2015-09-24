local awful   = require 'awful'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local alsa    = require 'alsa'
local volume  = require 'volume'
local vicious = require 'vicious'
local widgets = require 'widgets'


-- battery critical notification
local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end
local function bat_notification()
  local f_capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))
  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))
  if (bat_capacity <= 20 and bat_status == "Discharging") then
      naughty.notify({
          preset = naughty.config.presets.critical,
          text = lain.util.markup.bold("Critical battery!")
      })
  end
end
if hostname == "dell" then
    battimer = timer({ timeout = 120 })
    battimer:connect_signal("timeout", bat_notification)
    battimer:start()
end

function lay(layout, widget, background_color, left, right)
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

local function systembox_hide(screen)
    systembox[screen].visible = false
end
local function systembox_show(screen)
    systembox[screen].visible = true
end

for s = 1, screen.count() do
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s] = awful.wibox({ position = theme.statusbar_position, screen = s, height = theme.statusbar_height })
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                       awful.button({ }, 1, function() awful.layout.inc(layouts,  1) end),
                       awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
                       awful.button({ }, 4, function() awful.layout.inc(layouts,  1) end),
                       awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))
    mylayoutbox[s]:connect_signal("mouse::enter", function() systembox_show(mouse.screen) end)
    mylayoutbox[s]:connect_signal("mouse::leave", function() systembox_hide(mouse.screen) end)

    -- layouts

    local layout1 = wibox.layout.fixed.horizontal()
    lay(layout1, mylayoutbox[s])
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

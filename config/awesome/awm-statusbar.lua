local awful   = require 'awful'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local alsa    = require 'alsa'
local volume  = require 'volume'
local vicious = require 'vicious'


markup = lain.util.markup

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
      naughty.notify({ text = markup.bold("Critical battery!"), fg = "#ca0000", bg = "#eeeeee"
    })
  end
end
if hostname == "dell" then
    battimer = timer({timeout = 120})
    battimer:connect_signal("timeout", bat_notification)
    battimer:start()
end

function get_genmon(script)
    local command = os.getenv("HOME") .. "/.bin/lib/genmon/" .. script .. " awesome"
    local fh = assert(io.popen(command, "r"))
    local text = fh:read("*l")
    fh:close()
    return text
end

function make_widget(script, timeout)
    local new_widget = wibox.widget.textbox()
    new_widget:set_markup(get_genmon(script))
    local new_widget_timer = timer({ timeout = timeout })
    new_widget_timer:connect_signal("timeout",
        function() new_widget:set_markup(get_genmon(script)) end
    )
    new_widget_timer:start()
    return new_widget
end

if hostname == "dell" then batterywidget = make_widget("battery.sh", 5) end
if hostname == "dell" then netwidget     = make_widget("net.sh", 5) end
dropboxwidget = make_widget("dropbox.sh", 5)

volumewidget = alsa({
    timeout = 5,
    settings = function()
        if volume_now.status == "off" then
            widget:set_markup(markup.bold(markup(theme.widget_alsa_mute_fg, volume_now.level .. "   ")))
        else
            widget:set_markup(markup.bold(markup(theme.widget_alsa_fg, volume_now.level .. "   ")))
        end
    end
})
volumewidget.widget:buttons(awful.util.table.join(
       awful.button({ }, 4, function() volume.increase() end), -- wheel up
       awful.button({ }, 5, function() volume.decrease() end), -- wheel down
       awful.button({ }, 1, function() volume.toggle()   end), -- left click
       awful.button({ }, 3, function() volume.toggle()   end)  -- right click
))

datewidget = lain.widgets.base({
    timeout  = 2,
    cmd      = "date +'%a, %d.%m. %H:%M'",
    settings = function()
        local t_output = ""
        local o_it = string.gmatch(output, "%S+")
        widget:set_markup(markup(theme.widget_date_fg, o_it(1) .. " " .. o_it(1)) .. " " .. markup.bold(markup(theme.widget_date_fg, o_it(1))) .. "  ")
    end
})
lain.widgets.calendar:attach(datewidget, { font_size = 8, font = theme.widget_date_calendar_font })

speedwidget   = lain.widgets.net({
    notify = "off",
    settings = function()
        down_speed = math.floor(tonumber(net_now.received))
        up_speed   = math.floor(tonumber(net_now.sent))
        widget:set_markup(markup.bold(
            markup(theme.widget_speed_down, " ↓ " .. down_speed)
            .. " " ..
            markup(theme.widget_speed_up, " ↑ " .. up_speed .. "   ")))
    end
})

mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
    function(mpdwidget, args)
        if args["{state}"] == "Stop" or args["{state}"] == "Pause" then
            return "          "
        else
            return markup(theme.widget_mpd_fg, markup.bold(args["{Artist}"]) .. ' - ' .. args["{Title}"])
        end
    end, 2)
mpdwidget:buttons(awful.util.table.join(
                      awful.button({ }, 1, function() awful.util.spawn(user_terminal .. " -x ncmpcpp") end)
))

mywibox = {}
mylayoutbox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ }, 3, awful.tag.viewtoggle)
                    )

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = theme.statusbar_height })
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                       awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                       awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- layouts

    local layout1 = wibox.layout.fixed.horizontal()
    layout1:add(mylayoutbox[s])
    layout1:add(mpdwidget)
    layout1:add(mypromptbox[s])

    local layout2 = wibox.layout.fixed.horizontal()
    layout2:add(mytaglist[s])

    local layout3 = wibox.layout.fixed.horizontal()
    -- if s == 1 then layout3:add(wibox.widget.systray()) end
    layout3:add(dropboxwidget)
    layout3:add(speedwidget)
    if netwidget then layout3:add(netwidget) end
    layout3:add(volumewidget)
    if batterywidget then layout3:add(batterywidget) end
    layout3:add(datewidget)

    -- build status bar

    local align_left = wibox.layout.align.horizontal()
    align_left:set_left(layout1)

    local align_middle = wibox.layout.align.horizontal()
    align_middle:set_middle(layout2)

    local align_right = wibox.layout.align.horizontal()
    align_right:set_right(layout3)

    local layout = wibox.layout.flex.horizontal()
    layout:add(align_left)
    layout:add(align_middle)
    layout:add(align_right)

    mywibox[s]:set_widget(layout)
end

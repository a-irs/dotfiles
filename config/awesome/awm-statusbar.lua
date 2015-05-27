local awful   = require 'awful'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'


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
dropboxwidget = make_widget("dropbox.sh", 5)
soundwidget   = make_widget("pulseaudio.sh", 1)
netwidget     = make_widget("net.sh", 5)
datewidget    = make_widget("clock.sh", 2)
speedwidget   = lain.widgets.net({
    settings = function()
        down_speed = math.floor(tonumber(net_now.received))
        up_speed   = math.floor(tonumber(net_now.sent))
        if down_speed >= 5 or up_speed >= 5 then
            widget:set_markup(markup.bold(
                markup(theme.speed_widget_down, " ↓ " .. down_speed)
                .. " " ..
                markup(theme.speed_widget_up, " ↑ " .. up_speed .. "   ")))
        else
            widget:set_markup("")
        end
    end
})

mywibox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ }, 3, awful.tag.viewtoggle)
                    )

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 21 })

    -- layouts

    local layout1 = wibox.layout.fixed.horizontal()
    layout1:add(mypromptbox[s])

    local layout2 = wibox.layout.fixed.horizontal()
    layout2:add(mytaglist[s])

    local layout3 = wibox.layout.fixed.horizontal()
    -- if s == 1 then layout3:add(wibox.widget.systray()) end
    layout3:add(speedwidget)
    layout3:add(dropboxwidget)
    layout3:add(netwidget)
    layout3:add(soundwidget)
    if hostname == "dell" then layout3:add(batterywidget) end
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

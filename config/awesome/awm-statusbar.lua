local awful = require 'awful'
local wibox = require 'wibox'
local lain  = require 'lain'

markup = lain.util.markup

-- date, time
function genmon_date()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/clock.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
datewidget = wibox.widget.textbox()
datewidget:set_markup(genmon_date())
datewidgettimer = timer({ timeout = 2 })
datewidgettimer:connect_signal("timeout",
  function() datewidget:set_markup(genmon_date()) end
)
datewidgettimer:start()

-- battery
function genmon_battery()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/battery.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
batterywidget = wibox.widget.textbox()
batterywidget:set_markup(genmon_battery())
batterywidgettimer = timer({ timeout = 5 })
batterywidgettimer:connect_signal("timeout",
  function() batterywidget:set_markup(genmon_battery()) end
)
batterywidgettimer:start()

-- audio
function genmon_audio()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/pulseaudio.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
audiowidget = wibox.widget.textbox()
audiowidget:set_markup(genmon_audio())
audiowidgettimer = timer({ timeout = 1 })
audiowidgettimer:connect_signal("timeout",
  function() audiowidget:set_markup(genmon_audio()) end
)
audiowidgettimer:start()

-- net
netwidget = wibox.widget.textbox()
function genmon_net()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/net.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
netwidget = wibox.widget.textbox()
netwidget:set_markup(genmon_net())
netwidgettimer = timer({ timeout = 5 })
netwidgettimer:connect_signal("timeout",
  function() netwidget:set_markup(genmon_net()) end
)
netwidgettimer:start()


-- mpd
mpdwidget = lain.widgets.mpd({
    settings = function ()
        mpd_notification_preset = {
            timeout = 5,
            text = string.format("%s\n%s", markup.bold(mpd_now.artist), mpd_now.title)
        }
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
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netwidget)
    right_layout:add(audiowidget)
    right_layout:add(batterywidget)
    right_layout:add(datewidget)

    -- build status bar
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end

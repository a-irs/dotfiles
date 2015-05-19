local awful = require 'awful'
local wibox = require 'wibox'
local lain  = require 'lain'


markup = lain.util.markup

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

datewidget    = make_widget("clock.sh", 2)
batterywidget = make_widget("battery.sh", 5)
soundwidget   = make_widget("pulseaudio.sh", 1)
netwidget     = make_widget("net.sh", 5)

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
    left_layout:add(mypromptbox[s])

    -- middle
    local middle_layout = wibox.layout.fixed.horizontal()
    middle_layout:add(mytaglist[s])

    -- right
    local right_layout = wibox.layout.fixed.horizontal()
    -- if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netwidget)
    right_layout:add(soundwidget)
    right_layout:add(batterywidget)
    right_layout:add(datewidget)

    -- build status bar
    local align_left = wibox.layout.align.horizontal()
    align_left:set_left(left_layout)

    local align_middle = wibox.layout.align.horizontal()
    align_middle:set_middle(middle_layout)

    local align_right = wibox.layout.align.horizontal()
    align_right:set_right(right_layout)

    local layout = wibox.layout.flex.horizontal()
    layout:add(align_left)
    layout:add(align_middle)
    layout:add(align_right)

    mywibox[s]:set_widget(layout)
end

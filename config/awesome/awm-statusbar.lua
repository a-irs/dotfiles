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

mywibox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ }, 3, awful.tag.viewtoggle)
                    )
mytasklist = {}

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, false,
             { fg_focus = theme.tasklist_fg, bg_focus = theme.tasklist_bg, font = theme.tasklist_font })

    -- layouts

    local layout1 = wibox.layout.fixed.horizontal()
    layout1:add(mypromptbox[s])
    layout1:add(mytasklist[s])

    local layout2 = wibox.layout.fixed.horizontal()
    layout2:add(mytaglist[s])

    local layout3 = wibox.layout.fixed.horizontal()
    if s == 1 then layout3:add(wibox.widget.systray()) end
    layout3:add(netwidget)
    layout3:add(soundwidget)
    layout3:add(batterywidget)
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

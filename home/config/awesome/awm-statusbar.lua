local awful   = require 'awful'
local rules   = require 'awful.rules'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local volume  = require 'volume'
local gears   = require 'gears'

local markup = lain.util.markup


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

if is_mobile then
    batterywidget = lain.widget.bat({
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
    batterywidget_t = awful.tooltip({
        objects = { batterywidget.widget },
        timer_function = function()
            local handle = io.popen(gears.filesystem.get_configuration_dir() .. "/statusbar/battery-tooltip")
            local result = handle:read("*a")
            handle:close()
            return result
        end,
        timeout = 1,
    })
end


-- NETWORK

if is_mobile then
    netwidget = awful.widget.watch(
        gears.filesystem.get_configuration_dir() .. "/statusbar/net", 2,
        function(widget, stdout)
            widget:set_markup(stdout)
        end
    )
    netwidget_t = awful.tooltip({
        objects = { netwidget },
        timer_function = function()
            local handle = io.popen(gears.filesystem.get_configuration_dir() .. "/statusbar/net-tooltip")
            local result = handle:read("*a")
            handle:close()
            return result
        end,
        timeout = 2,
    })
end

-- DOWNLOAD STATUS

if hostname == "desk" then
    dlwidget = awful.widget.watch(
        gears.filesystem.get_configuration_dir() .. "/statusbar/dl-status.py", 2,
        function(widget, stdout)
            widget:set_markup(stdout)
        end
    )
end


-- MUSIC

musicwidget = awful.widget.watch(
    gears.filesystem.get_configuration_dir() .. "/statusbar/music.sh " .. theme.widget_music_fg:gsub('#', ''), 2,
    function(widget, stdout)
        if stdout == "" then
            widget:set_markup("")
        else
            widget:set_markup(stdout)
        end
    end
)


-- VOLUME

pulsewidget = lain.widget.pulse({
    timeout = 3,
    settings = function()
        local limit = 70
        if is_mobile then
            limit = 120
        end

        if tonumber(volume_now.left) == nil or tonumber(volume_now.right) == nil then
            widget:set_markup("no audio")
            return
        end
        local level = math.floor((volume_now.left + volume_now.right) / 2 / 5 + 0.5) * 5
        if volume_now.muted =="yes" then
            widget:set_markup(markup.bold(markup(theme.widget_pulse_mute_fg, level)))
        elseif level >= limit then
            widget:set_markup(markup.bold(markup("#ff3030", level)))
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

timewidget = wibox.widget.textclock(markup.bold(markup(theme.widget_time_fg, '%H:%M')))
datewidget = wibox.widget.textclock(markup(theme.widget_date_fg, '%a, %d.%m.'))
lain.widget.cal({
    attach_to = { timewidget, datewidget },
    notification_preset = {
        font = "Input 8",
        fg   = theme.fg_focus,
        bg   = theme.bg_focus
    }
})


local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
    )

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
end))

awful.screen.connect_for_each_screen(function(s)
    s.mywibox    = awful.wibox({ position = theme.statusbar_position, screen = s, height = theme.statusbar_height })
    s.myprompt   = awful.widget.prompt()

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons = tasklist_buttons,
        style = {
            fg_normal = theme.tasklist_fg,
            bg_normal = theme.tasklist_bg,
            font = theme.tasklist_font
        }
    }

    s.mytaglist  = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    s.systray = wibox.widget.systray()
    s.systray.visible = true

    -- layouts

    local m = dpi(3)

    local layout1 = wibox.layout.fixed.horizontal()
    lay(layout1, musicwidget, 0, 0, theme.bg_focus)
    lay(layout1, s.mytasklist)
    lay(layout1, s.myprompt)
    if hostname == "desk" then
        lay(layout1, dlwidget)
    end

    local layout2 = wibox.layout.fixed.horizontal()
    lay(layout2, s.mytaglist)

    local layout3 = wibox.layout.fixed.horizontal()
    lay(layout3, s.systray)
    lay(layout3, pulsewidget.widget, m)
    if is_mobile then
        lay(layout3, netwidget, m)
        lay(layout3, batterywidget.widget, m)
    end
    lay(layout3, datewidget, m, 0)
    lay(layout3, timewidget, m, m * 2)


    -- build status bar

    local layout = wibox.layout.align.horizontal()
    layout:set_expand("none")
    layout:set_left(layout1)
    layout:set_middle(layout2)
    layout:set_right(layout3)

    s.mywibox:set_widget(layout)
end)

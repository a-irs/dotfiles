local awful   = require 'awful'
local rules   = require 'awful.rules'
local wibox   = require 'wibox'
local lain    = require 'lain'
local naughty = require 'naughty'
local volume  = require 'volume'
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
end


-- NETWORK
if hostname == "dell" then
    netwidget = lain.widget.watch({
        timeout = 2,
        cmd = os.getenv("HOME") .. "/.config/awesome/network-info.sh",
        settings = function()
            widget:set_markup(output)
        end
    })
end

-- MUSIC

musicwidget = lain.widget.watch({
    timeout = 2,
    cmd = os.getenv("HOME") .. "/.config/awesome/music.sh " .. theme.widget_music_fg:gsub('#', ''),
    settings = function()
        if output == "" then
            widget:set_markup("")
        else
            widget:set_markup(output)
        end
    end
})
musicwidget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function() -- left click
        local matcher = function(c)
            return rules.match(c, {class = 'Spotify'})
        end
        awful.client.run_or_raise('spotify', matcher)
    end)
))


-- VOLUME

pulsewidget = lain.widget.pulseaudio({
    timeout = 3,
    settings = function()
        if volume_now.left == nil or volume_now.right == nil then
            widget:set_markup("ERROR")
            return
        end
        local level = math.floor((volume_now.left + volume_now.right) / 2 / 5 + 0.5) * 5
        if volume_now.muted =="yes" then
            widget:set_markup(markup.bold(markup(theme.widget_pulse_mute_fg, level)))
        elseif level >= 100 then
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
lain.widget.calendar.attach(datewidget, {
    font_size = "8",
    font = "Monospace",
    fg   = theme.fg_focus,
    bg   = theme.bg_focus
})
lain.widget.calendar.attach(timewidget, {
    font_size = "8",
    font = "Monospace",
    fg   = theme.fg_focus,
    bg   = theme.bg_focus
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
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            client.focus = c
            c:raise()
        end
end))

awful.screen.connect_for_each_screen(function(s)
    s.mytaglist  = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
    s.mywibox    = awful.wibox({ position = theme.statusbar_position, screen = s, height = theme.statusbar_height })
    s.myprompt   = awful.widget.prompt()
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.minimizedcurrenttags, tasklist_buttons, { fg_normal = theme.tasklist_fg, bg_normal = theme.tasklist_bg, font = theme.tasklist_font })


    -- layouts

    local m = 3

    local layout1 = wibox.layout.fixed.horizontal()
    lay(layout1, musicwidget.widget, 0, 0, theme.bg_focus)
    lay(layout1, s.mytasklist)
    lay(layout1, s.myprompt)

    local layout2 = wibox.layout.fixed.horizontal()
    lay(layout2, s.mytaglist)

    local layout3 = wibox.layout.fixed.horizontal()
    -- lay(layout3, wibox.widget.systray())
    lay(layout3, pulsewidget.widget, m)
    if hostname == "dell" then
        lay(layout3, netwidget.widget, m)
    end
    lay(layout3, batterywidget, m)
    lay(layout3, datewidget, m, 2)
    lay(layout3, timewidget, m, m * 2)


    -- build status bar

    local layout = wibox.layout.align.horizontal()
    layout:set_expand("none")
    layout:set_left(layout1)
    layout:set_middle(layout2)
    layout:set_right(layout3)

    s.mywibox:set_widget(layout)
end)

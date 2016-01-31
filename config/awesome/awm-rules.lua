local awful     = require 'awful'
local rules     = require 'awful.rules'
                  require 'awful.autofocus'
local beautiful = require 'beautiful'
local wibox     = require 'wibox'

rules.rules = {
    { rule = { class = "mpv" }, properties = { size_hints_honor = false } },
    { rule = { },
      properties = { focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons },
      callback = awful.client.setslave },
}

local function dynamic_tagging()
    for s = 1, screen.count() do
        for _, t in ipairs(awful.tag.gettags(s)) do
            if is_empty(t) then
                t.name = "□"
            else
                name = ""
                for _, c in ipairs(t:clients()) do
                    if c.class == nil or c.class == "" or c.class == "Kupfer.py" then
                        break
                    elseif c.instance == "play.google.com__music_listen" or (c.name and string.find(c.name, 'ncmpcpp')) then
                        name = name == "" and "music" or name .. ", music"
                    elseif c.name and string.find(c.name, 'ssh ') then
                        name = name == "" and "ssh" or name .. ", ssh"
                    elseif c.class == "Firefox" then
                        name = name == "" and "firefox" or name .. ", firefox"
                    elseif string.find(c.class:lower(), "libreoffice") then
                        name = name == "" and "office" or name .. ", office"
                    elseif c.class == "Subl3" then
                        name = name == "" and "sublime" or name .. ", sublime"
                    elseif c.class == "Thunar" then
                        name = name == "" and "files" or name .. ", files"
                    elseif c.class == "Termite" then
                        name = name == "" and "term" or name .. ", term"
                    else
                        name = name == "" and c.class:lower() or name .. ", " .. c.class:lower()
                    end
                end
                t.name = " ■ " .. name .. " "
            end
        end
    end
end

local t = timer({ timeout = 2 })
t:connect_signal("timeout",
    function()
        dynamic_tagging()
    end
)
t:start()

local function handle_floater(c)
    c.ontop = awful.client.floating.get(c)
    awful.placement.centered(c)
end

dynamic_tagging()

-- floating → set always on top
client.connect_signal("property::floating", function(c)
    handle_floater(c)
end)

-- client appears
client.connect_signal("manage", function(c)

    handle_floater(c)

    -- sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- titlebar

    if c.type == "normal" or c.type == "dialog" then
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
        )

        local layout1 = wibox.layout.fixed.horizontal()
        layout1:add(awful.titlebar.widget.closebutton(c))
        layout1:add(awful.titlebar.widget.floatingbutton(c))
        layout1:add(awful.titlebar.widget.stickybutton(c))

        local layout2 = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_font(theme.titlebar_font)
        layout2:add(title)
        layout2:buttons(buttons)

        local layout = wibox.layout.align.horizontal()
        layout:set_expand("none")
        layout:set_left(layout1)
        layout:set_middle(layout2)

        awful.titlebar(c, { size = theme.titlebar_height }):set_widget(layout)
    end

    if compact_display then awful.titlebar.hide(c) end

    dynamic_tagging()


    if (c.class == "Kodi") then
        c.fullscreen = true
        t = awful.tag.gettags(1)[#awful.tag.gettags(1)]
        awful.client.movetotag(t, c)
        awful.tag.viewonly(t)
    end
end)

-- client exits
client.connect_signal("unmanage", function(c)

    -- return to last tag and reset settings when last window is closed
    if is_empty(awful.tag.selected()) then
        awful.tag.setmwfact(0.5)
        awful.tag.setnmaster(1)
        awful.tag.setncol(1)
        if c.class ~= "Kupfer.py" then awful.tag.history.restore() end
    end

    dynamic_tagging()
end)

client.connect_signal("tagged",   dynamic_tagging)
client.connect_signal("untagged", dynamic_tagging)

-- set focus to client under mouse cursor when switching tags
-- tag.connect_signal("property::selected", function(t)
--     local selected = tostring(t.selected) == "false"
--     if selected then
--         local focus_timer = timer({ timeout = 0.05 })
--         focus_timer:connect_signal("timeout", function()
--             local c = awful.mouse.client_under_pointer()
--             if not (c == nil) then
--                 client.focus = c
--                 c:raise()
--             end
--             focus_timer:stop()
--         end)
--         focus_timer:start()
--     end
-- end)

local awful     = require 'awful'
local rules     = require 'awful.rules'
                  require 'awful.autofocus'
local wibox     = require 'wibox'
local naughty   = require 'naughty'

rules.rules = {
    { rule = { class = "mpv" },   properties = { size_hints_honor = false } },
    { rule = { class = "Gpick" }, properties = { floating = true } },
    { rule = { },
      properties = { border_width = theme.border_width,
                     border_color = theme.border_normal,
                     focus = awful.client.focus.filter,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     maximized_vertical   = false,
                     maximized_horizontal = false },
      callback = awful.client.setslave },
}

local function make_name(existing_clients, client, wanted_name)
    if client.minimized then
        wanted_name = "[" .. wanted_name .. "]"
    elseif client.fullscreen then
        wanted_name = wanted_name .. "^"
    end

    if client.machine and client.machine ~= hostname then
        wanted_name = wanted_name .. " [" .. client.machine .. "]"
    end

    if existing_clients == nil or existing_clients == "" then
        return wanted_name
    else
        return existing_clients .. ", " .. wanted_name
    end
end

local function dynamic_tagging()
    awful.screen.connect_for_each_screen(function(s)
        for _, t in ipairs(awful.tag.gettags(s)) do
            append = ""
            if t.layout and t.layout.name == "floating" then
                append = "[f]"
            end
            if is_empty(t) then
                t.name = " " .. theme.taglist_empty_tag .. " " .. append
            else
                local name = ""
                for _, c in ipairs(t:clients()) do
                    if c.class == "Kupfer.py" then
                        break
                    elseif c.name and string.find(c.name, '(Private Browsing)') then
                        name = make_name(name, c, "web[*]")
                    elseif c.name and c.name == "Grafana - dash" then
                        name = "dashboard"
                    elseif c.instance == "play.google.com__music_listen" or (c.name and string.find(c.name, 'ncmpcpp')) then
                        name = make_name(name, c, "music")
                    elseif c.name and string.find(c.name, 'ssh ') then
                        name = make_name(name, c, "ssh")
                    elseif c.class == "Firefox" or c.class == "Chrome" or c.class == "Chromium" then
                        name = make_name(name, c, "web")
                    elseif c.class ~= nil and string.find(c.class:lower(), "libreoffice") then
                        name = make_name(name, c, "office")
                    elseif c.class == "VirtualBox" and string.find(c.name, 'alpine ') then
                        name = make_name(name, c, "alpine-vm")
                    elseif c.class == "VirtualBox" and string.find(c.name, 'xp ') then
                        name = make_name(name, c, "xp-vm")
                    elseif c.class == "Subl3" then
                        name = make_name(name, c, "sublime")
                    elseif c.class == "Thunar" or c.class == "Pcmanfm" then
                        name = make_name(name, c, "files")
                    elseif c.class == "Gimp-2.8" then
                        name = make_name(name, c, "gimp")
                    elseif c.name and (string.find(c.name, 'vim ') or string.find(c.name, ' - VIM')) then
                        name = make_name(name, c, "vim")
                    elseif c.class == "Termite" then
                        name = make_name(name, c, "term")
                    elseif c.class == "Gpicview" then
                        name = make_name(name, c, "image")
                    elseif c.class == "Engrampa" then
                        name = make_name(name, c, "archive")
                    elseif c.class == "Zathura" then
                        name = make_name(name, c, "pdf")
                    elseif c.class == "jetbrains-idea" then
                        name = make_name(name, c, "intelliJ")
                    else
                        if c.class == nil or c.class == "" then
                            if c.name then
                                name = make_name(name, c, c.name:lower())
                            end
                        else
                            name = make_name(name, c, c.class:lower())
                        end
                    end
                end
                t.name = " " .. theme.taglist_nonempty_tag .. " " .. name .. " " .. append
            end
        end
    end)
end

local t = timer({ timeout = 1 })
t:connect_signal("timeout",
    function()
        dynamic_tagging()
    end
)
t:start()

local function handle_floater(c)
    c.ontop = awful.client.floating.get(c)
end

dynamic_tagging()

-- floating → set always on top
client.connect_signal("property::floating", function(c)
    handle_floater(c)
end)

-- client appears
client.connect_signal("manage", function(c)

    if (c.class == "Kupfer.py") then
        return
    end

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

    if (c.class == "Kodi") then
        c.fullscreen = true
        t = awful.tag.add("kodi")
        awful.tag.setvolatile(true, t)
        awful.client.movetotag(t, c)
        awful.tag.viewonly(t)
    elseif c.class == "Steam" or c.name == "Steam" then
        t = awful.tag.add("steam")
        awful.tag.setvolatile(true, t)
        awful.client.movetotag(t, c)
    end

end)

-- client exits
client.connect_signal("unmanage", function(c)

    if (c.class == "Kupfer.py") then
        return
    end

    -- return to last tag and reset settings when last window is closed
    if is_empty(awful.tag.selected()) then
        if c.class ~= "Kupfer.py" then
            awful.tag.setmwfact(0.5)
            awful.tag.setnmaster(1)
            awful.tag.setncol(1)
            awful.tag.history.restore()
        end
        -- return to last non-empty tag
        i = 2
        while is_empty(awful.tag.selected()) and i <= 4 do
            awful.tag.history.restore(nil, i)
            i = i + 1
        end

        -- if still empty, return to first
        if is_empty(awful.tag.selected()) then
            local tag = awful.tag.gettags(awful.screen.focused())[1]
            if tag then awful.tag.viewonly(tag) end
        end
    end

    dynamic_tagging()
end)

client.connect_signal("tagged",   dynamic_tagging)
client.connect_signal("untagged", dynamic_tagging)
client.connect_signal("property::minimized", dynamic_tagging)

client.connect_signal("focus",   function(c) c.border_color = theme.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = theme.border_normal end)

tag.connect_signal("property::layout", function(t)
    naughty.notify({ text = awful.tag.getproperty(t, "layout").name, timeout = 2, position = "top_middle" })
end)

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

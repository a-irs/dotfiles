local volume     = require 'volume'
local awful      = require 'awful'
local rules      = require 'awful.rules'
local naughty    = require 'naughty'
local gears      = require 'gears'

win = "Mod4"
alt = "Mod1"

function tag_view_nonempty(direction)
    local s = awful.screen.focused()
    for i = 1, #awful.tag.gettags(s) do
        awful.tag.viewidx(direction, s)
        if #awful.client.visible(s) > 0 then
            return
        end
    end
end

function run_gui(cmd)
    awful.spawn(cmd, { tag = mouse.screen.selected_tag })
end

function run(cmd)
    awful.spawn(cmd, false)
end

function run_script(script)
    run(os.getenv("HOME") .. "/.bin/" .. script)
end

function run_gui_script(script)
    run_gui(os.getenv("HOME") .. "/.bin/" .. script)
end

function run_or_raise(cmd, class)
    local matcher = function(c)
        return rules.match(c, {class = class})
    end
    awful.client.run_or_raise(cmd, matcher)
end

function focus(direction)
    awful.client.focus.bydirection(direction)
    if client.focus then client.focus:raise() end
end

function view_tag(i)
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
        tag:view_only()
    end
end

function toggle_tag(i)
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
        awful.tag.viewtoggle(tag)
    end
end

function move_client_to_tag(i)
    if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end


globalkeys = awful.util.table.join(

    -- focus windows

    awful.key({ alt }, "Down",  function() focus("down") end),
    awful.key({ alt }, "Up",    function() focus("up") end),
    awful.key({ alt }, "Left",  function() focus("left") end),
    awful.key({ alt }, "Right", function() focus("right") end),

    -- switch tags

    awful.key({ win          }, "Right", awful.tag.viewnext),
    awful.key({ win          }, "Left",  awful.tag.viewprev),
    awful.key({ alt          }, "Tab",   function() tag_view_nonempty( 1) end),
    awful.key({ alt, "Shift" }, "Tab",   function() tag_view_nonempty(-1) end),
    awful.key({ win          }, "Tab",   awful.tag.history.restore),

    -- modify windows

    awful.key({ win }, "Down",  function()
        for _, t in ipairs(awful.tag.selectedlist(1)) do
            for _, c in ipairs(t:clients()) do
                if c.minimized then
                    c.minimized = false
                    client.focus = c
                    c:raise()
                    break
                end
            end
        end
    end),

    -- useless gaps

    awful.key({ win }, "#35", function() awful.tag.incgap(-1) end), -- plus +
    awful.key({ win }, "#61", function() awful.tag.incgap( 1) end), -- minus -

    awful.key({ win, "Control" }, "Right", function() awful.tag.incmwfact( 0.01) end,
        {description="increase window size", group="window"}),

    awful.key({ win, "Control" }, "Left",  function() awful.tag.incmwfact(-0.01) end,
        {description="decrease window size", group="window"}),

    awful.key({ win, "Shift"   }, "Left",
        function()
            awful.client.swap.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description="swap with left window", group="window"}),
    awful.key({ win, "Shift"   }, "Right",
        function()
            awful.client.swap.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description="swap with right window", group="window"}),
    awful.key({ win, "Shift"   }, "Up",
        function()
            awful.client.swap.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description="swap with up window", group="window"}),
    awful.key({ win, "Shift"   }, "Down",
        function()
            awful.client.swap.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description="swap with down window", group="window"}),

    -- switch layouts

    awful.key({ win            }, "space", function() awful.layout.inc(1) end),
    awful.key({ win, "Shift"   }, "space", function() awful.layout.inc(-1) end),

    -- launch programs

    awful.key({ win }, "r",          function() awful.screen.focused().myprompt:run() end),
    awful.key({ alt }, "Return",     function() run("termite") end),
    awful.key({ alt }, "f",          function() run_gui("thunar") end),
    awful.key({ alt }, "c",          function() run_gui("firefox") end),
    awful.key({ alt, "Shift" }, "c", function() run_gui("firefox --private-window") end),
    awful.key({ alt }, "p",          function() run_script("pick-color.sh") end),
    awful.key({ alt }, "k",          function() run_or_raise("keepassxc", "keepassxc") end),
    awful.key({ alt }, "s",          function() run_or_raise("subl3", "Subl3") end),
    awful.key({ alt }, "o",          function() run_gui_script("mpv-clipboard.sh") end),

    -- displays

    awful.key({ win }, "p", function() run("bash -c 'sleep 0.1 && xset dpms force off'") end),
    awful.key({ "Ctrl", "Shift" }, "dead_circumflex", function() run_script("desk/toggle-display.sh") end),

    -- screenshots

    awful.key({        }, "Print", function() run("flameshot full -p " .. os.getenv("HOME")) end),
    awful.key({ "Ctrl" }, "Print", function() run("flameshot gui -p "  .. os.getenv("HOME")) end),

    -- media keys

    awful.key({}, "XF86AudioRaiseVolume", volume.increase),
    awful.key({}, "XF86AudioLowerVolume", volume.decrease),
    awful.key({}, "XF86AudioMute",        volume.toggle),

    awful.key({}, "XF86AudioPlay", function()
        io.popen("mpc -q toggle")
        io.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    end),
    awful.key({}, "XF86AudioPrev", function()
        io.popen("mpc -q prev")
        io.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
    end),
    awful.key({}, "XF86AudioNext", function()
        io.popen("mpc -q next")
        io.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
    end),

    awful.key({ alt }, "<", function()
        io.popen("mpc -q next")
        io.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
    end),
    awful.key({ alt, "Shift" }, "<", function()
        io.popen("mpc -q prev")
        io.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
    end),
    awful.key({ alt }, "y", function()
        io.popen("mpc -q toggle")
        io.popen("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    end),

    -- suspend, lock

    awful.key({ win }, "l",       function() run_script("screen-lock.sh") end),
    awful.key({}, "XF86PowerOff", function() run_script("screen-lock.sh suspend") end),

    -- restart awesome wm

    awful.key({ win, "Ctrl"  }, "r", awesome.restart),

    -- show all tags at once

    awful.key({ win }, "z",
    function()
        local screen = awful.screen.focused()
        local all_tags = screen.tags
        local selected_tags = awful.tag.selectedlist(screen)

        local all_tags_count = 0
        for _ in pairs(all_tags) do
            all_tags_count = all_tags_count + 1
        end

        local selected_tags_count = 0
        for _ in pairs(selected_tags) do
            selected_tags_count = selected_tags_count + 1
        end

        if all_tags_count == selected_tags_count then
            awful.tag.history.restore()
        else
            awful.tag.viewmore(all_tags, screen)
        end
    end),

    -- change master/column count

    awful.key({ win }, ".",
        function()
            awful.tag.incnmaster(1, nil, true)
            local text = "Number of master windows: " .. awful.tag.getnmaster()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="increase # of master windows", group="layout"}),
    awful.key({ win }, ",",
        function()
            awful.tag.incnmaster(-1, nil, true)
            local text = "Number of master windows: " .. awful.tag.getnmaster()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="decrease # of master windows", group="layout"}),
    awful.key({ win, alt }, ".",
        function()
            awful.tag.incncol(1, nil, true)
            local text = "Number of columns: " .. awful.tag.getncol()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="increase # of columns", group="layout"}),
    awful.key({ win, alt }, ",",
        function()
            awful.tag.incncol(-1, nil, true)
            local text = "Number of columns: " .. awful.tag.getncol()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="decrease # of columns", group="layout"})
)


clientkeys = gears.table.join(
    awful.key({ win }, "f",  function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    awful.key({ alt }, "F4", function(c) c:kill() end),
    awful.key({ win }, "w",  function(c) c:kill() end),
    awful.key({ win }, "q",  function(c) c:kill() end),
    awful.key({ win }, "e",  awful.client.floating.toggle),
    awful.key({ win }, "m",  awful.titlebar.toggle),
    awful.key({ win }, "Up", function(c) c.minimized = true end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ win },          "#" .. i + 9, function() view_tag(i) end),
        awful.key({ win, alt },     "#" .. i + 9, function() toggle_tag(i) end),
        awful.key({ win, "Shift" }, "#" .. i + 9, function() move_client_to_tag(i) end)
    )
end

-- mouse buttons

clientbuttons = awful.util.table.join(
    awful.button({     }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ win }, 1, awful.mouse.client.move),
    awful.button({ win }, 3, awful.mouse.client.resize)
)

root.keys(globalkeys)

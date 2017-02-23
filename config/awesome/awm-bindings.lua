local volume     = require 'volume'
local awful      = require 'awful'
local rules      = require 'awful.rules'
local naughty    = require 'naughty'
local beautiful  = require 'beautiful'

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

globalkeys = awful.util.table.join(

    -- focus windows

    awful.key({ alt }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description="focus down", group="focus"}),
    awful.key({ alt }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description="focus up", group="focus"}),
    awful.key({ alt }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description="focus left", group="focus"}),
    awful.key({ alt }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description="focus right", group="focus"}),

    -- toggle "compact display mode"

    awful.key({ win          }, "u", function()
        if compact_display then
            compact_display = false
            for _, c in ipairs(client.get()) do
                awful.titlebar.show(c)
            end
        else
            compact_display = true
            for _, c in ipairs(client.get()) do
                awful.titlebar.hide(c)
            end
        end
    end,
    {description="toggle compact mode", group="useless"}),

    -- switch tags

    awful.key({ win          }, "Right", awful.tag.viewnext,
        {description="view right tag", group="tags"}),
    awful.key({ win          }, "Left",  awful.tag.viewprev,
        {description="view left tag", group="tags"}),

    awful.key({ alt          }, "Tab",   function() tag_view_nonempty( 1) end,
        {description="view right nonempty tag", group="tags"}),

    awful.key({ alt, "Shift" }, "Tab",   function() tag_view_nonempty(-1) end,
        {description="view left nonempty tag", group="tags"}),

    awful.key({ win          }, "Tab",   awful.tag.history.restore,
        {description="toggle history tag", group="tags"}),

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

    awful.key({ win }, "#35", function() -- plus +
        awful.tag.incgap(-1)
    end, {description="increase useless gap", group="useless"}),

    awful.key({ win }, "#61", function() -- minus -
        awful.tag.incgap(1)
    end, {description="decrease useless gap", group="useless"}),

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

    awful.key({ win            }, "space", function() awful.layout.inc(layouts,  1) end,
        {description="next layout", group="layout"}),

    awful.key({ win, "Shift"   }, "space", function() awful.layout.inc(layouts, -1) end,
        {description="previous layout", group="layout"}),

    -- launch programs

    awful.key({ win }, "r", function () awful.screen.focused().myprompt:run() end,
        {description = "run prompt", group = "apps"}),

    awful.key({ win }, "p", function() awful.spawn("bash -c 'sleep 0.1 && xset dpms force off'") end,
        {description = "turn off LCD", group = "apps" }),

    awful.key({ alt }, "Return", function() awful.spawn(user_terminal) end,
              {description = "run terminal", group = "apps"}),
    awful.key({ alt }, "f",      function() awful.spawn("thunar") end,
              {description = "run filemanager", group = "apps"}),
    awful.key({ alt }, "c",      function() awful.spawn('chromium')
        end, {description = "run browser", group = "apps"}),
    awful.key({ alt, "Shift" }, "c", function () awful.spawn("chromium --incognito") end,
              {description = "run private browser", group = "apps"}),
    awful.key({ win }, "l",      function () awful.spawn(os.getenv("HOME") .. "/.bin/screen-lock.sh", false) end,
              {description = "lock screen", group = "apps"}),
    awful.key({ alt }, "p",      function () awful.spawn(os.getenv("HOME") .. "/.bin/pick-color.sh", false) end,
              {description = "run color picker", group = "apps"}),
    awful.key({ alt }, "k",      function()
        local matcher = function(c)
            return rules.match(c, {class = 'Keepassx2'})
        end
        awful.client.run_or_raise('keepassx2', matcher)
    end, {description = "run keepass", group = "apps"}),
    awful.key({ alt }, "s",      function()
            local matcher = function(c)
                return rules.match(c, {class = 'Subl3'})
            end
            awful.client.run_or_raise('subl3', matcher)
        end, {description = "run sublime text", group = "apps"}),
    awful.key({ alt }, "o",      function () awful.spawn(os.getenv("HOME") .. "/.bin/mpv-clipboard.sh", false) end,
              {description = "run mpv-clipboard.sh", group = "apps"}),

    awful.key({ "Ctrl", "Shift" }, "dead_circumflex", function() awful.spawn(os.getenv("HOME") .. "/.bin/desk/toggle-res.sh") end,
              {description = "toggle screen resolution", group = "apps"}),
    awful.key({        }, "Print", function() awful.spawn("mate-screenshot", false) end,
              {description = "make screenshot", group = "apps"}),
    awful.key({ "Ctrl" }, "Print", function() awful.spawn("mate-screenshot --area", false) end,
              {description = "make screenshot", group = "apps"}),

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

    awful.key({}, "XF86PowerOff", function() awful.spawn(os.getenv("HOME") .. "/.bin/screen-lock.sh suspend", false) end),

    -- restart awesome wm

    awful.key({ win, "Ctrl"  }, "r", awesome.restart),

    -- toggle status bars

    awful.key({ win }, "b",
        function()
            mywibox[awful.screen.focused()].visible = not mywibox[awful.screen.focused()].visible
        end,
        {description="toggle main status bar", group="bars"}),

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
              end,
        {description="show all tags", group="tags"}),

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

clientkeys = awful.util.table.join(
    awful.key({ win }, "f",  function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    awful.key({ alt }, "F4", function(c) c:kill() end),
    awful.key({ win }, "w",  function(c) c:kill() end),
    awful.key({ win }, "q",  function(c) c:kill() end),
    awful.key({ win }, "e",  awful.client.floating.toggle),
    awful.key({ win }, "m",  awful.titlebar.toggle, { description="toggle active window titlebar", group="bars"}),
    awful.key({ win }, "Up",  function(c) c.minimized = true end)
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- view tag
        awful.key({ win }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end),
        -- toggle tag display
        awful.key({ win, alt }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end),
        -- move client to tag
        awful.key({ win, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end)
        )
end

clientbuttons = awful.util.table.join(
    awful.button({     }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ win }, 1, awful.mouse.client.move),
    awful.button({ win }, 3, awful.mouse.client.resize)
)

root.keys(globalkeys)

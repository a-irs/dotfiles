local volume     = require 'volume'
local awful      = require 'awful'
local lain       = require 'lain'
local naughty    = require 'naughty'
local beautiful  = require 'beautiful'
local hotkeys_popup = require("awful.hotkeys_popup.widget")

-- TODO: refactor
hotkeys_popup.height = math.floor(vres/1.5)
hotkeys_popup.width = math.floor(hres/1.5)
hotkeys_popup.modifiers_color = "#777777"
hotkeys_popup.description_font = "Monospace 9"
hotkeys_popup.labels['Mod4'] = "Win"
hotkeys_popup.labels['#35'] = "+"
hotkeys_popup.labels['#61'] = "-"
hotkeys_popup.labels['dead_circumflex'] = "^"

win = "Mod4"
alt = "Mod1"

globalkeys = awful.util.table.join(

    awful.key({ win }, "s",      hotkeys_popup.show_help,
              {description="show keybindings", group="awesome"} ),

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

    awful.key({ alt          }, "Tab",   function() lain.util.tag_view_nonempty( 1) end,
        {description="view right nonempty tag", group="tags"}),

    awful.key({ alt, "Shift" }, "Tab",   function() lain.util.tag_view_nonempty(-1) end,
        {description="view left nonempty tag", group="tags"}),

    awful.key({ win          }, "Tab",   awful.tag.history.restore,
        {description="toggle history tag", group="tags"}),

    -- modify windows

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


    awful.key({ win }, "r",
        function()
            awful.util.spawn("rofi \
                -disable-history \
                -show run \
                -opacity 100 \
                -width 50 \
                -lines 10 \
                -bw 5 \
                -bg '" .. theme.bg_focus .. "' \
                -bc '" .. theme.bg_focus .. "' \
                -fg '#ddd' \
                -hlbg '" .. theme.bg_normal .. "' \
                -hlfg '#fff' \
                -font 'Monospace 11' \
                -no-parse-known-hosts \
                -terminal " .. user_terminal,
            false)
        end,
        {description = "run prompt", group = "apps"}),

    awful.key({ alt }, "Return", function () awful.util.spawn(user_terminal) end,
              {description = "run terminal", group = "apps"}),
    awful.key({ alt }, "f",      function () awful.util.spawn("thunar") end,
              {description = "run thunar", group = "apps"}),
    awful.key({ alt }, "c",      function () awful.util.spawn("chromium") end,
              {description = "run browser", group = "apps"}),
    awful.key({ alt, "Shift" }, "c", function () awful.util.spawn("chromium --incognito") end,
              {description = "run private browser", group = "apps"}),
    awful.key({ win }, "l",      function () awful.util.spawn(os.getenv("HOME") .. "/.bin/screen-lock.sh", false) end,
              {description = "lock screen", group = "apps"}),
    awful.key({ alt }, "p",      function () awful.util.spawn(os.getenv("HOME") .. "/.bin/pick-color.sh", false) end,
              {description = "run color picker", group = "apps"}),
    awful.key({ alt }, "s",      function () awful.util.spawn("subl3") end,
              {description = "run sublime text", group = "apps"}),
    awful.key({ alt }, "o",      function () awful.util.spawn(os.getenv("HOME") .. "/.bin/mpv-clipboard.sh", false) end,
              {description = "run mpv-clipboard.sh", group = "apps"}),

    awful.key({ "Ctrl", "Shift" }, "dead_circumflex", function() awful.util.spawn(os.getenv("HOME") .. "/.bin/desktop/toggle-res.sh") end,
              {description = "toggle screen resolution", group = "apps"}),
    awful.key({ }, "Print", function() awful.util.spawn("scrot " .. os.getenv("HOME") .. "/%Y-%m-%d_%H-%M-%S.png", false) end,
              {description = "make screenshot", group = "apps"}),

    -- media keys

    awful.key({}, "XF86AudioRaiseVolume", volume.increase),
    awful.key({}, "XF86AudioLowerVolume", volume.decrease),
    awful.key({}, "XF86AudioMute",        volume.toggle),

    awful.key({}, "XF86AudioPlay", function() io.popen("mpc -q toggle") end),
    awful.key({}, "XF86AudioPrev", function() io.popen("mpc -q prev") end),
    awful.key({}, "XF86AudioNext", function() io.popen("mpc -q next") end),

    awful.key({}, "XF86PowerOff", function() awful.util.spawn(os.getenv("HOME") .. "/.bin/screen-lock.sh suspend", false) end),

    -- restart awesome wm

    awful.key({ win, "Shift" }, "r", awesome.restart),
    awful.key({ win, "Ctrl"  }, "r", awesome.restart),

    -- toggle status bars

    awful.key({ win }, "b",
        function()
            mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        end,
        {description="toggle main status bar", group="bars"}),


    awful.key({ win }, "n",
        function()
            systembox[mouse.screen].visible = not systembox[mouse.screen].visible
        end,
        {description="toggle system status bar", group="bars"}),

    -- show all tags at once

    awful.key({ win }, "z",
              function()
                  local screen = mouse.screen
                  local all_tags = awful.tag.gettags(screen)
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
            awful.tag.incnmaster(1)
            local text = "Number of master windows: " .. awful.tag.getnmaster()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="increase # of master windows", group="layout"}),
    awful.key({ win }, ",",
        function()
            awful.tag.incnmaster(-1)
            local text = "Number of master windows: " .. awful.tag.getnmaster()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="decrease # of master windows", group="layout"}),
    awful.key({ win, alt }, ".",
        function()
            awful.tag.incncol(1)
            local text = "Number of columns: " .. awful.tag.getncol()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="increase # of columns", group="layout"}),
    awful.key({ win, alt }, ",",
        function()
            awful.tag.incncol(-1)
            local text = "Number of columns: " .. awful.tag.getncol()
            naughty.notify({ text = text, timeout = 1 })
        end,
        {description="decrease # of columns", group="layout"})
)

clientkeys = awful.util.table.join(
    awful.key({ win }, "f",  function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ alt }, "F4", function(c) c:kill() end),
    awful.key({ win }, "w",  function(c) c:kill() end),
    awful.key({ win }, "q",  function(c) c:kill() end),
    awful.key({ win }, "m",  awful.titlebar.toggle, { description="toggle active window titlebar", group="bars"})
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- view tag
        awful.key({ win }, "#" .. i + 9,
            function()
                local tag = awful.tag.gettags(mouse.screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end),
        -- toggle tag
        awful.key({ win, alt }, "#" .. i + 9,
            function()
                local tag = awful.tag.gettags(mouse.screen)[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end),
        -- move client to tag
        awful.key({ win, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.movetotag(tag)
                    end
                end
            end)
        )
end

clientbuttons = awful.util.table.join(
    awful.button({     }, 1,      function(c) client.focus = c; c:raise() end),
    awful.button({ win }, 1,      awful.mouse.client.move),
    awful.button({ win, alt }, 1, awful.mouse.client.dragtotag.border),
    awful.button({ win }, 3,      awful.mouse.client.resize))

root.buttons(awful.util.table.join(
    awful.button({     }, 3,      function() awful.util.spawn("xfce4-appfinder --disable-server") end)
))

root.keys(globalkeys)

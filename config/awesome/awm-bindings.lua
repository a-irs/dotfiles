local volume     = require 'volume'
local awful      = require 'awful'
local lain       = require 'lain'
local naughty    = require 'naughty'
local revelation = require 'revelation'
local beautiful  = require 'beautiful'

revelation.init({tag_name = ''})

win = "Mod4"
alt = "Mod1"

globalkeys = awful.util.table.join(

    -- focus windows

    awful.key({ alt }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ alt }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ alt }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ alt }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- toggle "compact display mode"

    awful.key({ win          }, "u", function()
        if compact_display then
            compact_display = false
            beautiful.useless_gap = theme.useless_gap_normal
            for _, c in ipairs(client.get()) do
                awful.titlebar.show(c)
            end
        else
            compact_display = true
            beautiful.useless_gap = theme.useless_gap_compact
            for _, c in ipairs(client.get()) do
                awful.titlebar.hide(c)
            end
        end
        awful.layout.arrange(mouse.screen)
    end),

    -- switch tags

    awful.key({ win          }, "Right", awful.tag.viewnext),
    awful.key({ win          }, "Left",  awful.tag.viewprev),

    awful.key({ alt          }, "Tab",   function() lain.util.tag_view_nonempty( 1) end),
    awful.key({ alt, "Shift" }, "Tab",   function() lain.util.tag_view_nonempty(-1) end),

    awful.key({ win          }, "Tab",   awful.tag.history.restore),

    awful.key({              }, "F12",
      function ()
          local screen = mouse.screen
          local tag = awful.tag.gettags(screen)[2]
          if tag then
              if tag.selected then
                awful.tag.history.restore()
              else
                awful.tag.viewonly(tag)
              end
          end
      end),

    -- modify windows

    awful.key({ win }, "+", function()
        if beautiful.useless_gap <= 4 then
            beautiful.useless_gap = 0
        elseif beautiful.useless_gap ~= 0 then
            beautiful.useless_gap = beautiful.useless_gap - 4
        end
        awful.layout.arrange(mouse.screen)
    end),
    awful.key({ win }, "-", function()
        beautiful.useless_gap = beautiful.useless_gap + 4
        awful.layout.arrange(mouse.screen)
    end),

    awful.key({ win, "Control" }, "Right", function() awful.tag.incmwfact( 0.01) end),
    awful.key({ win, "Control" }, "Left",  function() awful.tag.incmwfact(-0.01) end),

    awful.key({ win, "Shift"   }, "Left",
        function()
            awful.client.swap.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ win, "Shift"   }, "Right",
        function()
            awful.client.swap.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ win, "Shift"   }, "Up",
        function()
            awful.client.swap.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ win, "Shift"   }, "Down",
        function()
            awful.client.swap.bydirection("down")
            if client.focus then client.focus:raise() end
        end),

    -- switch layouts

    awful.key({ win            }, "space", function() awful.layout.inc(layouts,  1) end),
    awful.key({ win, "Shift"   }, "space", function() awful.layout.inc(layouts, -1) end),

    -- launch programs

    awful.key({ win }, "r",      function () awful.util.spawn("rofi -show run -bg    '" .. theme.bg_normal .. "' -bc '" .. theme.bg_normal .. "' -fg '#ddd' -hlbg '#666' -hlfg '#fff' -font 'Input 11' -width 30 -padding 10 -terminal " .. user_terminal) end),
    awful.key({ win, alt }, "r", function () awful.util.spawn("rofi -show window -bg '" .. theme.bg_normal .. "' -bc '" .. theme.bg_normal .. "' -fg '#ddd' -hlbg '#666' -hlfg '#fff' -font 'Input 11' -width 30 -padding 10 -terminal " .. user_terminal) end),
    awful.key({ alt }, "Return", function () awful.util.spawn(user_terminal) end),
    awful.key({ alt }, "f",      function () awful.util.spawn("thunar") end),
    awful.key({ alt }, "c",      function () awful.util.spawn("firefox") end),
    awful.key({ win }, "l",      function () awful.util.spawn(os.getenv("HOME") .. "/.bin/screen-lock.sh") end),
    awful.key({ alt }, "p",      function () awful.util.spawn(os.getenv("HOME") .. "/.bin/pick-color.sh") end),
    awful.key({ alt }, "s",      function () awful.util.spawn("subl3") end),

    awful.key({ "Ctrl", "Shift" }, "dead_circumflex", function()
        awful.util.spawn(os.getenv("HOME") .. "/.bin/desktop/toggle-res.sh")
    end),

    -- media keys

    awful.key({}, "XF86AudioRaiseVolume", volume.increase),
    awful.key({}, "XF86AudioLowerVolume", volume.decrease),
    awful.key({}, "XF86AudioMute",        volume.toggle),

    awful.key({}, "XF86AudioPlay", function() io.popen("mpc -q toggle") end),
    awful.key({}, "XF86AudioPrev", function() io.popen("mpc -q prev") end),
    awful.key({}, "XF86AudioNext", function() io.popen("mpc -q next") end),

    awful.key({}, "XF86PowerOff", function() awful.util.spawn(os.getenv("HOME") .. "/.bin/screen-lock.sh suspend") end),

    -- restart awesome wm

    awful.key({ win, "Shift" }, "r", awesome.restart),
    awful.key({ win, "Ctrl"  }, "r", awesome.restart),

    -- toggle status bars

    awful.key({ win }, "b", function()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    awful.key({ win }, "n", function()
        systembox[mouse.screen].visible = not systembox[mouse.screen].visible
    end),

    -- expose

    awful.key({ win }, "e", revelation),

    -- screenshot

    awful.key({ }, "Print", function() awful.util.spawn("scrot " .. os.getenv("HOME") .. "/%Y-%m-%d_%H-%M-%S.png") end),

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
              end),

    -- change master/column count

    awful.key({ win }, ".", function()
        awful.tag.incnmaster(1)
        local text = "Number of master windows: " .. awful.tag.getnmaster()
        naughty.notify({ text = text, timeout = 1 })
    end),
    awful.key({ win }, ",", function()
        awful.tag.incnmaster(-1)
        local text = "Number of master windows: " .. awful.tag.getnmaster()
        naughty.notify({ text = text, timeout = 1 })
    end),
    awful.key({ win, alt }, ".", function()
        awful.tag.incncol(1)
        local text = "Number of columns: " .. awful.tag.getncol()
        naughty.notify({ text = text, timeout = 1 })
    end),
    awful.key({ win, alt }, ",", function()
        awful.tag.incncol(-1)
        local text = "Number of columns: " .. awful.tag.getncol()
        naughty.notify({ text = text, timeout = 1 })
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ win }, "f",  function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ alt }, "F4", function(c) c:kill() end),
    awful.key({ win }, "w",  function(c) c:kill() end),
    awful.key({ win }, "q",  function(c) c:kill() end),
    awful.key({ win }, "m",  awful.titlebar.toggle)
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

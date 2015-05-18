local volume = require 'volume'
local awful  = require 'awful'


win = "Mod4"
alt = "Mod1"

globalkeys = awful.util.table.join(
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

    awful.key({ win,           }, "Tab", awful.tag.history.restore),

    awful.key({ win, }, "+", function () lain.util.useless_gaps_resize(-5) end),
    awful.key({ win, }, "-", function () lain.util.useless_gaps_resize(5) end),

    awful.key({ win }, "Right", awful.tag.viewnext),
    awful.key({ win }, "Left", awful.tag.viewprev),

    -- Standard programs
    awful.key({ alt }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ alt }, "f", function () awful.util.spawn("thunar") end),
    awful.key({ alt }, "c", function () awful.util.spawn("firefox") end),
    awful.key({ win }, "l", function () awful.util.spawn("xflock4") end),
    awful.key({ alt }, "s", function () awful.util.spawn("subl3") end),

    awful.key({ win, "Shift"   }, "r", awesome.restart),

    awful.key({ win, "Control"          }, "Right",     function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ win, "Control"          }, "Left",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ win,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ win, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ win,           }, "u", awful.client.urgent.jumpto),
    awful.key({ win, "Shift"   }, "Left",  function () awful.client.swap.byidx(  1)    end),
    awful.key({ win, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end),

    awful.key({ win },            "r",    function () mypromptbox[mouse.screen]:run() end),

    awful.key({}, "XF86AudioRaiseVolume", function () volume.increase() end),
    awful.key({}, "XF86AudioLowerVolume", function () volume.decrease() end),
    awful.key({}, "XF86AudioMute",        function () volume.toggle() end),

    awful.key({  }, "F12",
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
          end)
)

clientkeys = awful.util.table.join(
    awful.key({ win, }, "f",  function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ alt  }, "F4", function (c) c:kill()                         end)
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ win }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ win, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ win, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ win, alt }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ win }, 1, awful.mouse.client.move),
    awful.button({ win }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

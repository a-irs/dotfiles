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

    -- switch tags

    awful.key({ win          }, "Right", awful.tag.viewnext),
    awful.key({ win          }, "Left",  awful.tag.viewprev),

    awful.key({ alt          }, "Tab",   function() lain.util.tag_view_nonempty( 1) end),
    awful.key({ alt, "Shift" }, "Tab",   function() lain.util.tag_view_nonempty(-1) end),

    awful.key({ win          }, "Tab",   awful.tag.history.restore),
    awful.key({ win          }, "u",     awful.client.urgent.jumpto),

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
      if beautiful.useless_gap_width <= 4 then
        lain.util.useless_gaps_resize(-beautiful.useless_gap_width)
      elseif beautiful.useless_gap_width ~= 0 then
        lain.util.useless_gaps_resize(-5)
      end
    end),
    awful.key({ win }, "-", function() lain.util.useless_gaps_resize(5) end),

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

    awful.key({ win            }, "space", function () awful.layout.inc(layouts, 1) end),
    awful.key({ win, "Shift"   }, "space", function () awful.layout.inc(layouts,-1) end),

    -- launch programs

    awful.key({ win }, "r",      function () awful.util.spawn("rofi -show run -bg '#2d2d2d' -bc '#2d2d2d' -fg '#ddd' -hlbg '#666' -hlfg '#fff' -font 'Input 11' -width 30 -padding 10 -terminal " .. user_terminal) end),
    awful.key({ alt }, "Return", function () awful.util.spawn(user_terminal) end),
    awful.key({ alt }, "f",      function () awful.util.spawn("thunar") end),
    awful.key({ alt }, "c",      function () awful.util.spawn("firefox") end),
    awful.key({ win }, "l",      function () awful.util.spawn("xflock4") end),
    awful.key({ alt }, "s",      function () awful.util.spawn("subl3") end),

    -- media keys

    awful.key({}, "XF86AudioRaiseVolume", function()
      volume.increase()
    end),
    awful.key({}, "XF86AudioLowerVolume", function()
      volume.decrease()
    end),
    awful.key({}, "XF86AudioMute",        function()
      ismute = volume.toggle()
    end),

    -- restart awesome wm
    awful.key({ win, "Shift" }, "r", awesome.restart),

    -- toggle status bar
    awful.key({ win }, "b", function ()
       mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- expose
    awful.key({ win }, "e", revelation)
)

clientkeys = awful.util.table.join(
    awful.key({ win }, "f",  function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ alt }, "F4", function(c) c:kill() end),
    awful.key({ win }, "w",  function(c) c:kill() end),
    awful.key({ win }, "q",  function(c) c:kill() end)
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
    awful.button({ },     1, function(c) client.focus = c; c:raise() end),
    awful.button({ win }, 1, awful.mouse.client.move),
    awful.button({ win }, 3, awful.mouse.client.resize))

root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev),
    awful.button({ win }, 4, function()
      if beautiful.useless_gap_width <= 4 then
        lain.util.useless_gaps_resize(-beautiful.useless_gap_width)
      elseif beautiful.useless_gap_width ~= 0 then
        lain.util.useless_gaps_resize(-5)
      end
    end),
    awful.button({ win }, 5, function() lain.util.useless_gaps_resize(5) end)
))

root.keys(globalkeys)

local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
                  require("awful.autofocus")
local tyrannical = require("tyrannical")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local lain      = require("lain")


if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "An error happened!",
                         text = err })
        in_error = false
    end)
end

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end
run_once("kupfer --no-splash")
run_once("compton -b")
run_once(os.getenv("HOME") .. "/.bin/redshift.sh")
-- }}

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

terminal = "terminator"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

win = "Mod4"
alt = "Mod1"

local layouts =
{
--    awful.layout.suit.tile,
    lain.layout.uselessfair.horizontal,
    lain.layout.uselessfair,
--    lain.layout.uselesstile,
--    awful.layout.suit.tile.left,
  --  lain.layout.uselesstile.left,
  --  awful.layout.suit.tile.bottom,
    --lain.layout.uselesstile.bottom,
   -- awful.layout.suit.tile.top,
    --lain.layout.uselesstile.top,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}


-- {{{ Tags
--[[
tags = {
   names = { "www", "zsh", "dev", "file" },
   layout = { layouts[1], layouts[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
--]]

tyrannical.tags = {
    {
        name        = "www",
        init        = true,
        exclusive   = true,
        -- icon        = "/home/alex/.icons/menu.png",
        layout      = lain.layout.uselessfair,
        exec_once   = { "firefox" },
        class       = { "firefox", "chromium" }
    },
    {
        name        = "zsh",
        init        = true,
        exclusive   = true,
        layout      = lain.layout.uselessfair.horizontal,
        exec_once   = { "terminator" },
        class       = { "urxvt", "terminator" }
    },
    {
        name        = "dev",
        init        = true,
        exclusive   = true,
        layout      = lain.layout.uselessfair.horizontal,
        exec_once   = { "subl3" },
        class       = { "subl3" }
    },
    {
        name        = "file",
        init        = true,
        exclusive   = true,
        layout      = lain.layout.uselessfair,
        exec_once   = { "thunar" },
        class       = { "thunar", "engrampa" }
    },
    {
        name        = "doc",
        init        = false,
        exclusive   = true,
        layout      = lain.layout.uselessfair.horizontal,
        class       = { "evince" }
    },
    {
        name        = "img",
        init        = false,
        exclusive   = true,
        layout      = awful.layout.suit.max.fullscreen,
        class       = { "gpicview" }
    },
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "kupfer.py",
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer",
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "kcalc"
}

tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client
-- }}}



-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })


-- {{{ Wibox
markup      = lain.util.markup

-- Create a textclock widget
mytextclock = awful.widget.textclock(markup("#ffffff", "%a, %d.%m.") .. markup.bold(markup("#ffffff", " %H:%M  ")), 1)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ }, 3, awful.tag.viewtoggle)
                    )


for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)

    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

globalkeys = awful.util.table.join(
    awful.key({ win }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ win }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ win }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ win }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    awful.key({ win,           }, "Tab", awful.tag.history.restore),

    awful.key({ win, }, "+", function () lain.util.useless_gaps_resize(-5) end),
    awful.key({ win, }, "-", function () lain.util.useless_gaps_resize(5) end),

    -- Alt-Tab
    awful.key({ alt,           }, "Tab", awful.tag.viewnext),
    awful.key({ alt, "Shift"   }, "Tab", awful.tag.viewprev),

    -- Standard programs
    awful.key({ alt }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ alt }, "f", function () awful.util.spawn("thunar") end),
    awful.key({ alt }, "c", function () awful.util.spawn("firefox") end),
    awful.key({ alt }, "s", function () awful.util.spawn("subl3") end),

    awful.key({ win, "Shift"   }, "r", awesome.restart),

    awful.key({ win, "Control"          }, "Right",     function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ win, "Control"          }, "Left",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ win,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ win, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ win,           }, "u", awful.client.urgent.jumpto),
    awful.key({ win, "Shift"   }, "Left", function () awful.client.swap.byidx(  1)    end),
    awful.key({ win, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end),

    awful.key({ win },            "r",     function () mypromptbox[mouse.screen]:run() end)
)

clientkeys = awful.util.table.join(
    awful.key({ win, }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ alt  }, "F4",      function (c) c:kill()                         end)
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

-- {{{ Rules
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

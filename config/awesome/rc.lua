local gears      = require("gears")
local awful      = require("awful")
awful.rules      = require("awful.rules")
                   require("awful.autofocus")
local tyrannical = require("tyrannical")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
local lain       = require("lain")
local vicious    = require("vicious")
local volume     = require("volume")

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
-- disable startup-notification (loading cursor)
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
  oldspawn(s, false)
end

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end
run_once("start-pulseaudio-x11")
run_once("mpd")
run_once("thunar --daemon")
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
    lain.layout.uselessfair.horizontal,
    lain.layout.uselessfair,
--    awful.layout.suit.tile,
--    lain.layout.uselesstile,
--    awful.layout.suit.tile.left,
--    lain.layout.uselesstile.left,
--    awful.layout.suit.tile.bottom,
--    lain.layout.uselesstile.bottom,
--    awful.layout.suit.tile.top,
--    lain.layout.uselesstile.top,
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
tyrannical.tags = {
    {
        name        = "www",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair,
        class       = { "firefox", "chromium" }
    },
    {
        name        = "zsh",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair.horizontal,
        exec_once   = { "terminator" },
        class       = { "urxvt", "terminator" }
    },
    {
        name        = "dev",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair.horizontal,
        class       = { "subl3", "atom" }
    },
    {
        name        = "files",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair,
        class       = { "thunar", "engrampa" }
    },
    {
        name        = "doc",
        init        = false,
        exclusive   = false,
        layout      = lain.layout.uselessfair.horizontal,
        class       = { "evince" }
    },
    {   name        = "img",
        init        = false,
        exclusive   = false,
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


-- {{{ Key bindings
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
    awful.key({ alt }, "f", function () awful.util.spawn("Thunar") end),
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



-- {{{ Wibox
markup      = lain.util.markup

-- date, time
function genmon_date()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/clock.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
datewidget = wibox.widget.textbox()
datewidget:set_markup(genmon_date())
datewidgettimer = timer({ timeout = 2 })
datewidgettimer:connect_signal("timeout",
  function() datewidget:set_markup(genmon_date()) end
)
datewidgettimer:start()

-- battery
function genmon_battery()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/battery.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
batterywidget = wibox.widget.textbox()
batterywidget:set_markup(genmon_battery())
batterywidgettimer = timer({ timeout = 5 })
batterywidgettimer:connect_signal("timeout",
  function() batterywidget:set_markup(genmon_battery()) end
)
batterywidgettimer:start()

-- audio
function genmon_audio()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/pulseaudio.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
audiowidget = wibox.widget.textbox()
audiowidget:set_markup(genmon_audio())
audiowidgettimer = timer({ timeout = 1 })
audiowidgettimer:connect_signal("timeout",
  function() audiowidget:set_markup(genmon_audio()) end
)
audiowidgettimer:start()

-- net
netwidget = wibox.widget.textbox()
function genmon_net()
  local command = os.getenv("HOME") .. "/.bin/lib/genmon/net.sh awesome"
  local fh = assert(io.popen(command, "r"))
  local text = fh:read("*l")
  fh:close()
  return text
end
netwidget = wibox.widget.textbox()
netwidget:set_markup(genmon_net())
netwidgettimer = timer({ timeout = 5 })
netwidgettimer:connect_signal("timeout",
  function() netwidget:set_markup(genmon_net()) end
)
netwidgettimer:start()


-- mpd
mpdwidget = lain.widgets.mpd({
    settings = function ()
        mpd_notification_preset = {
            timeout = 5,
            text = string.format("%s\n%s", markup.bold(mpd_now.artist), mpd_now.title)
        }
    end
})



mywibox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ }, 3, awful.tag.viewtoggle)
                    )

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netwidget)
    right_layout:add(audiowidget)
    right_layout:add(batterywidget)
    right_layout:add(datewidget)

    -- build status bar
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

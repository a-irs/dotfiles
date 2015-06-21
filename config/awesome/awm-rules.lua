local awful     = require 'awful'
local rules     = require 'awful.rules'
                  require 'awful.autofocus'
local beautiful = require 'beautiful'
local wibox     = require 'wibox'


rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons },
      callback = awful.client.setslave },
}

dynamic_tagging = function()
    for s = 1, screen.count() do
        -- set name of tag without clients
        local atags = awful.tag.gettags(s)
        for i, t in ipairs(atags) do
            t.name = "○"
        end

        -- set name of tag with clients
        local clist = client.get(s)
        for i, c in ipairs(clist) do
            local ctags = c:tags()
            for i, t in ipairs(ctags) do
                t.name = "●"
            end
        end
    end
end

-- client appears
client.connect_signal("manage", function (c, startup)
    -- floating clients don't overlap, cover the titlebar or get placed offscreen
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
    dynamic_tagging()

    -- sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

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

        local button_layout = wibox.layout.fixed.horizontal()
        button_layout:add(awful.titlebar.widget.closebutton(c))
        button_layout:add(awful.titlebar.widget.floatingbutton(c))
        button_layout:add(awful.titlebar.widget.stickybutton(c))
        button_layout:add(awful.titlebar.widget.ontopbutton(c))

        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        title:set_font(theme.titlebar_font)
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        local layout = wibox.layout.align.horizontal()
        layout:set_left(button_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c, { size = theme.titlebar_height }):set_widget(layout)
    end

    -- hide titlebar by default on laptop
    if hostname ~= "desktop" then awful.titlebar.hide(c) end
end)

-- client exits
client.connect_signal("unmanage", function(c, startup)
  dynamic_tagging()

  -- return to last tag when last window is closed
  curtag = awful.tag.selected()
  for _, c in pairs(curtag:clients()) do
    return
  end
  awful.tag.history.restore()
end)

client.connect_signal("tagged",   function (c, startup) dynamic_tagging() end)
client.connect_signal("untagged", function (c, startup) dynamic_tagging() end)
client.connect_signal("focus",    function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus",  function(c) c.border_color = beautiful.border_normal end)

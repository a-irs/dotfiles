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

    -- sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- floating clients don't overlap, cover the titlebar or get placed offscreen
    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    dynamic_tagging()

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

        -- set widgets for left, middle, right

        local layout1_1 = wibox.layout.fixed.horizontal()
        layout1_1:add(awful.titlebar.widget.closebutton(c))
        layout1_1:add(awful.titlebar.widget.floatingbutton(c))
        layout1_1:add(awful.titlebar.widget.stickybutton(c))
        layout1_1:add(awful.titlebar.widget.ontopbutton(c))

        -- needed to allow mouse clicks on the blank space between buttons and window title
        local layout1_2 = wibox.layout.flex.horizontal()
        layout1_2:buttons(buttons)

        local layout1 = wibox.layout.fixed.horizontal()
        layout1:add(layout1_1)
        layout1:add(layout1_2)

        local layout2 = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        title:set_font(theme.titlebar_font)
        layout2:add(title)
        layout2:buttons(buttons)

        local layout3 = wibox.layout.flex.horizontal()
        layout3:buttons(buttons)

        -- build title bar

        local align_left = wibox.layout.align.horizontal()
        align_left:set_left(layout1)

        local align_middle = wibox.layout.align.horizontal()
        align_middle:set_middle(layout2)

        local align_right = wibox.layout.align.horizontal()
        align_right:set_right(layout3)

        local layout = wibox.layout.flex.horizontal()
        layout:add(align_left)
        layout:add(align_middle)
        layout:add(align_right)

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

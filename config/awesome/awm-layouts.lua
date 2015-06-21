local awful = require 'awful'
local lain  = require 'lain'

layouts = {
    -- lain.layout.termfair,
    -- lain.layout.centerfair,
    -- lain.layout.cascade,
    -- lain.layout.cascadetile,
    -- lain.layout.centerwork,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
}

layouts_useless = {
    -- lain.layout.uselessfair.horizontal,
    -- lain.layout.uselessfair,
    -- lain.layout.uselesspiral,
    lain.layout.uselesstile,
    lain.layout.uselesstile.left,
    lain.layout.uselesstile.bottom,
    lain.layout.uselesstile.top,
}

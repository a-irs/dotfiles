local awful      = require 'awful'
local tyrannical = require 'tyrannical'
local lain       = require 'lain'


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children                = true
tyrannical.settings.mwfact                        = 0.5
tyrannical.settings.default_layout                = lain.layout.uselesstile

tyrannical.tags = {
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        mwfact      = 0.68,
        no_autofocus = true,
        nmaster     = 1,
        class       = { "Firefox", "Chromium" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        no_autofocus = true,
        nmaster     = 1,
        exec_once   = { user_terminal },
        class       = { "Urxvt", "Terminator", "Termite" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        no_autofocus = true,
        nmaster     = 1,
        class       = { "Subl3", "Atom" }
    },
    {   name        = "○",
        init        = true,
        nmaster     = 1,
        no_autofocus = true,
        fallback    = true,
    },
}
-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "Kupfer.py", "Gtksu", "Pinentry", "Gcolor2", "Gcolor3", "Colorgrab",
}
-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "Pinentry", "Plugin-container", "Gcolor3", "Colorgrab",
}
-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Pinentry", "Plugin-container", "Gcolor2", "Gcolor3", "Colorgrab",
}
-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "Gcolor2", "Gcolor3", "Colorgrab",
}

tyrannical.properties.sticky = {
    "Gcolor2", "Gcolor3", "Colorgrab",
}

tyrannical.properties.master = {
    "Firefox", "Atom",
}

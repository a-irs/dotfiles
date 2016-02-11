local awful      = require 'awful'
local lain       = require 'lain'


function make_name(icon, name)
    str = " "
    if icon == "globe" then
        str = str .. string.char(239, 130, 172)
    elseif icon == "desktop" then
        str = str .. string.char(239, 132, 136)
    elseif icon == "terminal" then
        str = str .. string.char(239, 132, 160)
    elseif icon == "file" then
        str = str .. string.char(239, 128, 150)
    elseif icon == "file-text" then
        str = str .. string.char(239, 133, 156)
    elseif icon == "list-alt" then
        str = str .. string.char(239, 128, 162)
    elseif icon == "cloud" then
        str = str .. string.char(239, 131, 130)
    elseif icon == "asterisk" then
        str = str .. string.char(239, 129, 169)
    elseif icon == "music" then
        str = str .. string.char(239, 128, 129)
    elseif icon == "picture" then
        str = str .. string.char(239, 128, 190)
    elseif icon == "video" then
        str = str .. string.char(239, 133, 170)
    end
    if name and theme.show_tag_names then
        if icon == nil then
            str = str .. name
        else
            str = str .. "  " .. name
        end
    end
    return str .. " "
end


if not enable_tyrannical then

    tags = {}
    for s = 1, screen.count() do
        tags[s] = awful.tag({
            make_name(nil, 1),
            make_name(nil, 2),
            make_name(nil, 3),
            make_name(nil, 4),
            make_name(nil, 5),
            }, s, layouts[1])
    end

else

    local tyrannical = require 'tyrannical'

    tyrannical.settings.block_children_focus_stealing = true
    tyrannical.settings.group_children                = true
    tyrannical.settings.mwfact                        = 0.5
    tyrannical.settings.default_layout                = layouts[1]
    default_nmaster                                   = 1

    if not compact_display then
        tyrannical.settings.mwfact                    = 0.68
        default_nmaster                               = 2
    end

    tyrannical.tags = {
        {
            name         = make_name("globe", "www"),
            init         = true,
            exclusive    = true,
            nmaster      = default_nmaster,
            class        = { "Firefox" }
        },
        {
            name         = make_name("terminal", "zsh"),
            init         = true,
            exclusive    = true,
            nmaster      = default_nmaster,
            exec_once    = { user_terminal },
            class        = { "Urxvt", "Terminator", "Termite" }
        },
        {
            name         = make_name("list-alt", "dev"),
            init         = true,
            exclusive    = true,
            nmaster      = default_nmaster,
            class        = { "Subl3", "Atom" }
        },
        {
            name         = make_name("desktop", "virtual"),
            init         = false,
            exclusive    = true,
            nmaster      = default_nmaster,
            class        = { "VirtualBox", "Qemu" }
        },
        {
            name         = make_name("music", "music"),
            init         = false,
            exclusive    = true,
            nmaster      = default_nmaster,
            class        = { "Ario", "Chromium" }
        },
        {
            name         = make_name("picture", "img"),
            init         = false,
            exclusive    = true,
            nmaster      = default_nmaster,
            class        = { "Gimp", "Gimp-2.8", "Pinta" }
        },
        {
            name         = make_name("video", "video"),
            init         = false,
            layout       = awful.layout.suit.fair,
            exclusive    = true,
            nmaster      = 2,
            class        = { "Mpv", "Vlc" }
        },
        {
            name         = make_name("asterisk", "apps"),
            init         = true,
            nmaster      = default_nmaster,
            fallback     = true,
        },
        {
            name         = make_name("video", "kodi"),
            init         = false,
            layout       = awful.layout.suit.max.fullscreen,
            class        = { "Kodi" }
        },
    }
    -- Ignore the tag "exclusive" property for the following clients (matched by classes)
    tyrannical.properties.intrusive = {
        "Kupfer.py", "Gtksu", "Pinentry", "Gcolor2", "Gcolor3", "Colorgrab", "Xfce4-appfinder",
    }
    -- Ignore the tiled layout for the matching clients
    tyrannical.properties.floating = {
        "Pinentry", "Plugin-container", "Gcolor3", "Colorgrab", "Xfce4-appfinder",
    }
    -- Make the matching clients (by classes) on top of the default layout
    tyrannical.properties.ontop = {
        "Pinentry", "Plugin-container", "Gcolor2", "Gcolor3", "Colorgrab", "Xfce4-appfinder",
    }
    -- Force the matching clients (by classes) to be centered on the screen on init
    tyrannical.properties.centered = {
        "Gcolor2", "Gcolor3", "Colorgrab", "Xfce4-appfinder",
    }

    tyrannical.properties.sticky = {
        "Gcolor2", "Gcolor3", "Colorgrab", "Xfce4-appfinder",
    }

    tyrannical.properties.master = {
        "Firefox", "Atom",
    }

    tyrannical.properties.fullscreen = {
        "Kodi",
    }

end

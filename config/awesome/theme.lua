local dpi = require("beautiful").xresources.apply_dpi
local xresources = require("beautiful").xresources

-- TODO: maybe use layout-icons from default-theme

if xresources.get_dpi() >= 168 then
    highdpi = true
end

theme                               = {}

theme.basedir                       = os.getenv("HOME") .. "/.config/awesome"

theme.statusbar_height              = dpi(24)
theme.statusbar_position            = "top"

-- FG, BG COLORS

theme.bg_normal                     = "#2c3643"
theme.bg_focus                      = "#3c4b5d"
theme.bg_urgent                     = "#aa0000"
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#ffffff"
theme.fg_urgent                     = "#af1d18"

theme.border_width                  = dpi(0)
theme.border_normal                 = theme.bg_normal
theme.border_focus                  = theme.bg_focus

theme.useless_gap_normal            = vertical_resolution/100
theme.useless_gap_compact           = 0

if compact_display then
    theme.useless_gap = theme.useless_gap_compact
else
    theme.useless_gap = theme.useless_gap_normal
end

-- NOTIFICATIONS (NAUGHTY)

theme.naughty_font                  = "Roboto Medium 8"
theme.naughty_padding               = dpi(12)
theme.naughty_spacing               = dpi(12)
theme.naughty_border_width          = dpi(6)
theme.naughty_timeout               = 4
theme.naughty_position              = "top_right"

theme.naughty_defaults_fg           = '#aaaaaa'
theme.naughty_defaults_bg           = '#222a34'
theme.naughty_defaults_border_color = theme.naughty_defaults_bg

theme.naughty_critical_fg           = '#ffffff'
theme.naughty_critical_bg           = '#fa5641'
theme.naughty_critical_border_color = theme.naughty_critical_bg


-- WIDGETS

theme.font                          = "Ubuntu 8"
theme.taglist_font                  = "FontAwesome Bold 8"
theme.show_tag_names                = true
if highdpi then
    theme.taglist_squares_unsel         = theme.basedir .. "/indicator175.png"
else
    theme.taglist_squares_unsel         = theme.basedir .. "/indicator.png"
end

theme.bg_systray                    = theme.bg_normal
theme.widget_mpd_fg                 = "#cfcfcf"
theme.widget_mpd_bg                 = theme.bg_normal
theme.widget_mpd_font               = "Roboto 8"
theme.widget_calendar_font          = "Input"
theme.widget_calendar_font_size     = 8
theme.widget_calendar_fg            = theme.fg_normal
theme.widget_calendar_bg            = "#222a34"
theme.widget_date_fg                = "#dfdfdf"
theme.widget_alsa_fg                = "#96b7e2"
theme.widget_alsa_mute_fg           = "#666666"
theme.widget_yawn_fg                = "#ababab"
theme.widget_speed_down             = "#ff8a5a"
theme.widget_speed_up               = theme.widget_speed_down
theme.widget_cpu_fg                 = "#ff6997"
theme.widget_cpu_graph_fg           = theme.widget_cpu_fg
theme.widget_cpu_graph_bg           = "#3d4b5c"
theme.widget_cpu_freq_fg            = "#9f96ff"
theme.widget_mem_fg                 = "#71ee5c"
theme.widget_load_fg                = "#80d9d8"
theme.widget_disk_read_fg           = "#ffc350"
theme.widget_disk_write_fg          = theme.widget_disk_read_fg


-- LAYOUT ICONS

if highdpi then
    layout_folder = theme.basedir .. "/layout175"
else
    layout_folder = theme.basedir .. "/layout"
end
theme.layout_tile                   = layout_folder .. "/tile.xpm"
theme.layout_tileleft               = layout_folder .. "/tileleft.xpm"
theme.layout_tilebottom             = layout_folder .. "/tilebottom.xpm"
theme.layout_tiletop                = layout_folder .. "/tiletop.xpm"
theme.layout_spiral                 = layout_folder .. "/spiral.xpm"

-- TITLEBAR

theme.titlebar_height                          = dpi(24)
theme.titlebar_font                            = "Roboto Bold 8"

theme.titlebar_fg_normal                       = theme.fg_normal
theme.titlebar_fg_focus                        = theme.fg_focus
theme.titlebar_bg_normal                       = theme.bg_normal
theme.titlebar_bg_focus                        = theme.bg_normal

if highdpi then
    titlebar_folder = theme.basedir .. "/titlebar175"
else
    titlebar_folder = theme.basedir .. "/titlebar"
end
theme.titlebar_close_button_focus              = titlebar_folder .. "/close.xpm"
theme.titlebar_close_button_normal             = titlebar_folder .. "/unfocused_inactive.xpm"
theme.titlebar_ontop_button_focus_inactive     = titlebar_folder .. "/ontop_inactive.xpm"
theme.titlebar_ontop_button_focus_active       = titlebar_folder .. "/ontop_active.xpm"
theme.titlebar_ontop_button_normal_inactive    = titlebar_folder .. "/ontop_inactive.xpm"
theme.titlebar_ontop_button_normal_active      = titlebar_folder .. "/ontop_unfocused.xpm"
theme.titlebar_sticky_button_focus_inactive    = titlebar_folder .. "/sticky_inactive.xpm"
theme.titlebar_sticky_button_focus_active      = titlebar_folder .. "/sticky_active.xpm"
theme.titlebar_sticky_button_normal_inactive   = titlebar_folder .. "/unfocused_inactive.xpm"
theme.titlebar_sticky_button_normal_active     = titlebar_folder .. "/unfocused_active.xpm"
theme.titlebar_floating_button_focus_inactive  = titlebar_folder .. "/floating_inactive.xpm"
theme.titlebar_floating_button_focus_active    = titlebar_folder .. "/floating_active.xpm"
theme.titlebar_floating_button_normal_inactive = titlebar_folder .. "/unfocused_inactive.xpm"
theme.titlebar_floating_button_normal_active   = titlebar_folder .. "/unfocused_active.xpm"

return theme

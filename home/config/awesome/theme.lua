local gears = require("gears")

theme                               = {}

-- theme.master_width_factor           = 0.78
-- theme.master_fill_policy            = "master_width_factor"

if is_high_dpi then
    xpm_folder                      = gears.filesystem.get_configuration_dir() .. "/xpm_175"
else
    xpm_folder                      = gears.filesystem.get_configuration_dir() .. "/xpm_100"
end

theme.statusbar_height              = dpi(18)
theme.statusbar_position            = "top"

-- FG, BG COLORS

theme.bg_normal                     = "#263657"
theme.bg_focus                      = "#364b73"
theme.bg_urgent                     = "#aa0000"
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#ffffff"
theme.fg_urgent                     = "#ffffff"

theme.border_width                  = dpi(0)
theme.border_normal                 = "#3f405f"
theme.border_focus                  = "#d9304f"

theme.useless_gap                   = 0

-- NOTIFICATIONS (NAUGHTY)

theme.naughty_font                  = "Fira Sans Medium 8"
theme.naughty_padding               = dpi(18)
theme.naughty_spacing               = dpi(18)
theme.naughty_border_width          = dpi(6)
theme.naughty_timeout               = 6
theme.naughty_position              = "top_right"

theme.naughty_defaults_fg           = theme.fg_focus
theme.naughty_defaults_bg           = theme.bg_focus
theme.naughty_defaults_border_color = theme.naughty_defaults_bg

theme.naughty_critical_fg           = '#ffffff'
theme.naughty_critical_bg           = '#F05F4D'
theme.naughty_critical_border_color = theme.naughty_critical_bg


-- WIDGETS

theme.font                          = "cure.se 8"
theme.taglist_font                  = "cure.se 6"
theme.show_tag_names                = true
-- theme.taglist_squares_unsel         = xpm_folder .. "/indicator.xpm"
theme.taglist_empty_tag             = "\28"
theme.taglist_nonempty_tag          = "\27"

if is_high_dpi then
    theme.font = "Input Bold 7"
    theme.taglist_font = "Input Bold 7"
    theme.taglist_empty_tag = "☐"  -- ○
    theme.taglist_nonempty_tag = "■"  -- ●
end

theme.tasklist_font                 = theme.font
theme.tasklist_fg                   = theme.fg_focus
theme.tasklist_bg                   = theme.bg_normal
theme.tasklist_disable_icon         = true

theme.bg_systray                    = theme.bg_normal
theme.systray_icon_spacing          = dpi(2)
theme.widget_music_fg               = theme.fg_focus
theme.widget_date_fg                = "#cccccc"
theme.widget_time_fg                = "#eeeeee"
theme.widget_pulse_fg               = "#96b7e2"
theme.widget_pulse_mute_fg          = "#666666"

-- TITLEBAR

theme.titlebar_height                          = dpi(24)
theme.titlebar_font                            = "Fira Sans Medium 8"

theme.titlebar_fg_normal                       = theme.fg_normal
theme.titlebar_fg_focus                        = theme.fg_focus
theme.titlebar_bg_normal                       = theme.bg_normal
theme.titlebar_bg_focus                        = theme.bg_normal

theme.titlebar_close_button_focus              = xpm_folder .. "/titlebar/close.xpm"
theme.titlebar_close_button_normal             = xpm_folder .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_ontop_button_focus_inactive     = xpm_folder .. "/titlebar/ontop_inactive.xpm"
theme.titlebar_ontop_button_focus_active       = xpm_folder .. "/titlebar/ontop_active.xpm"
theme.titlebar_ontop_button_normal_inactive    = xpm_folder .. "/titlebar/ontop_inactive.xpm"
theme.titlebar_ontop_button_normal_active      = xpm_folder .. "/titlebar/ontop_unfocused.xpm"
theme.titlebar_sticky_button_focus_inactive    = xpm_folder .. "/titlebar/sticky_inactive.xpm"
theme.titlebar_sticky_button_focus_active      = xpm_folder .. "/titlebar/sticky_active.xpm"
theme.titlebar_sticky_button_normal_inactive   = xpm_folder .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_sticky_button_normal_active     = xpm_folder .. "/titlebar/unfocused_active.xpm"
theme.titlebar_floating_button_focus_inactive  = xpm_folder .. "/titlebar/floating_inactive.xpm"
theme.titlebar_floating_button_focus_active    = xpm_folder .. "/titlebar/floating_active.xpm"
theme.titlebar_floating_button_normal_inactive = xpm_folder .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_floating_button_normal_active   = xpm_folder .. "/titlebar/unfocused_active.xpm"

return theme
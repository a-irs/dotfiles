local naughty = require 'naughty'

naughty.config.padding                       = theme.naughty_padding
naughty.config.spacing                       = theme.naughty_spacing

naughty.config.defaults.font                 = theme.naughty_font
naughty.config.defaults.fg                   = theme.naughty_defaults_fg
naughty.config.defaults.bg                   = theme.naughty_defaults_bg
naughty.config.defaults.border_color         = theme.naughty_defaults_border_color
naughty.config.defaults.border_width         = theme.naughty_border_width
naughty.config.defaults.timeout              = theme.naughty_timeout
naughty.config.defaults.position             = theme.naughty_position

naughty.config.presets.critical.font         = theme.naughty_font
naughty.config.presets.critical.fg           = theme.naughty_critical_fg
naughty.config.presets.critical.bg           = theme.naughty_critical_bg
naughty.config.presets.critical.border_color = theme.naughty_critical_border_color
naughty.config.presets.critical.border_width = theme.naughty_border_width
naughty.config.presets.critical.timeout      = theme.naughty_timeout
naughty.config.presets.critical.position     = theme.naughty_position

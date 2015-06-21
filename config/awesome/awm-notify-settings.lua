local naughty = require 'naughty'

naughty.config.padding                   = 12
naughty.config.spacing                   = 12

naughty.config.defaults.font         = "Roboto Medium 8"
naughty.config.defaults.fg           = '#aaaaaa'
naughty.config.defaults.bg           = '#222a34'
naughty.config.defaults.border_color = naughty.config.defaults.bg
naughty.config.defaults.border_width = 6
naughty.config.defaults.timeout      = 10
naughty.config.defaults.position     = "top_right"

naughty.config.presets.critical.font         = naughty.config.defaults.font
naughty.config.presets.critical.fg           = '#ffffff'
naughty.config.presets.critical.bg           = '#fa5641'
naughty.config.presets.critical.border_color = naughty.config.presets.critical.bg
naughty.config.presets.critical.border_width = naughty.config.defaults.border_width
naughty.config.presets.critical.timeout      = 10
naughty.config.presets.critical.position     = naughty.config.defaults.position

local newtimer        = require("lain.helpers").newtimer
local wibox           = require("wibox")
local io              = { popen  = io.popen }
local string          = { match  = string.match,
                          format = string.format }
local setmetatable    = setmetatable

local pulse = {}

local function worker(args)
    local args     = args or {}
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    local round = false

    pulse.widget = wibox.widget.textbox()

    function pulse.update()
        volume_now = {}

        local f = assert(io.popen("pacmd dump"))
        local out = f:read("*a")
        f:close()
        local default_sink = string.match(out, "set%-default%-sink ([^\n]+)")
        for sink, value in out:gmatch("set%-sink%-volume ([^%s]+) (0x%x+)") do
            if sink == default_sink then
                volume_now.level = math.floor(tonumber(value) / 0x10000 * 100)
            end
        end

        local m
        for sink, value in out:gmatch("set%-sink%-mute ([^%s]+) (%a+)") do
            if sink == default_sink then
                m = value
            end
        end

        volume_now.mute = m == "yes"

        if round then
            if tonumber(volume_now.level) == 0 then
                volume_now.level = 0
            elseif tonumber(volume_now.level) <= 7 then
                volume_now.level = 5
            elseif tonumber(volume_now.level) <= 12 then
                volume_now.level = 10
            elseif tonumber(volume_now.level) <= 17 then
                volume_now.level = 15
            elseif tonumber(volume_now.level) <= 22 then
                volume_now.level = 20
            elseif tonumber(volume_now.level) <= 27 then
                volume_now.level = 25
            elseif tonumber(volume_now.level) <= 32 then
                volume_now.level = 30
            elseif tonumber(volume_now.level) <= 37 then
                volume_now.level = 35
            elseif tonumber(volume_now.level) <= 42 then
                volume_now.level = 40
            elseif tonumber(volume_now.level) <= 47 then
                volume_now.level = 45
            elseif tonumber(volume_now.level) <= 52 then
                volume_now.level = 50
            elseif tonumber(volume_now.level) <= 57 then
                volume_now.level = 55
            elseif tonumber(volume_now.level) <= 62 then
                volume_now.level = 60
            elseif tonumber(volume_now.level) <= 67 then
                volume_now.level = 65
            elseif tonumber(volume_now.level) <= 72 then
                volume_now.level = 70
            elseif tonumber(volume_now.level) <= 77 then
                volume_now.level = 75
            elseif tonumber(volume_now.level) <= 82 then
                volume_now.level = 80
            elseif tonumber(volume_now.level) <= 87 then
                volume_now.level = 85
            elseif tonumber(volume_now.level) <= 92 then
                volume_now.level = 90
            elseif tonumber(volume_now.level) <= 97 then
                volume_now.level = 95
            else
                volume_now.level = 100
            end
        end

        widget = pulse.widget
        settings()
    end

    newtimer("pulse", timeout, pulse.update)

    return setmetatable(pulse, { __index = pulse.widget })
end

return setmetatable(pulse, { __call = function(_, ...) return worker(...) end })

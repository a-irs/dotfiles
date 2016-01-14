local newtimer        = require("lain.helpers").newtimer
local wibox           = require("wibox")
local io              = { open  = io.open }
local setmetatable    = setmetatable

local battery = {}

local function worker(args)
    local args     = args or {}
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    battery.widget = wibox.widget.textbox()

    function battery.update()
        local f = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
        local l = tonumber(f:read("*l"))
        f:close()

        local f2 = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))
        local s = f2:read("*l")
        f2:close()

        battery_now = {}
        battery_now.level = l
        battery_now.status = s:match'^%s*(.*%S)'

        if battery_now.level > 100 then
            battery_now.level = 100
        end

        if battery_now.level < 0 then
            battery_now.level = 0
        end

        widget = battery.widget
        settings()
    end

    newtimer("battery", timeout, battery.update)

    return setmetatable(battery, { __index = battery.widget })
end

return setmetatable(battery, { __call = function(_, ...) return worker(...) end })

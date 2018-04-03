#!/usr/bin/env bash

t=$(< /sys/class/drm/card0/device/hwmon/hwmon1/temp1_input)
temp=$((t/1000))
echo "$temp°C"

if [[ $1 == auto ]]; then
    echo 0 | sudo tee /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable > /dev/null
    echo "set fan speed to automatic"
elif [[ $1 && $1 -ge 0 && $1 -le 100 ]]; then
    echo 1 | sudo tee /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable > /dev/null
    s=$(($1*255/100))
    echo "$s" | sudo tee /sys/class/drm/card0/device/hwmon/hwmon0/pwm1 > /dev/null
fi

speed=$(< /sys/class/drm/card0/device/hwmon/hwmon1/pwm1)
echo "fan speed: $speed/255"

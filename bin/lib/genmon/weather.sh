#!/usr/bin/env bash

update_period=600
weather_location="684294"

run_segment() {
    local tmp_file="/tmp/weather_yahoo.txt"
    local weather=$(__yahoo_weather)
    if [ -n "$weather" ]; then
        echo "$weather"
    fi
}

__yahoo_weather() {
    degree=""
    if [ -f "$tmp_file" ]; then
        last_update=$(stat -c "%Y" ${tmp_file})
        time_now=$(date +%s)

        up_to_date=$(echo "(${time_now}-${last_update}) < ${update_period}" | bc)
        if [ "$up_to_date" -eq 1 ]; then
            __read_tmp_file
        fi
    fi

    if [ -z "$degree" ]; then
        weather_data=$(curl --max-time 4 -s "http://weather.yahooapis.com/forecastrss?w=${weather_location}&u=c")
        if [ "$?" -eq "0" ]; then
            error=$(echo "$weather_data" | grep "problem_cause\|DOCTYPE");
            if [ -n "$error" ]; then
                echo "error"
                exit 1
            fi

            # <yweather:units temperature="F" distance="mi" pressure="in" speed="mph"/>
            unit=$(echo "$weather_data" | grep -Zo "<yweather:units [^<>]*/>" | sed 's/.*temperature="\([^"]*\)".*/\1/')
            condition=$(echo "$weather_data" | grep -Zo "<yweather:condition [^<>]*/>")
            # <yweather:condition  text="Clear"  code="31"  temp="66"  date="Mon, 01 Oct 2012 8:00 pm CST" />
            degree=$(echo "$condition" | sed 's/.*temp="\([^"]*\)".*/\1/')
            condition=$(echo "$condition" | sed 's/.*text="\([^"]*\)".*/\1/')
            # Pull the times for sunrise and sunset so we know when to change the day/night indicator
            # <yweather:astronomy sunrise="6:56 am"   sunset="6:21 pm"/>
            sunrise=$(date -d"$(echo "$weather_data" | grep "yweather:astronomy" | sed 's/^\(.*\)sunset.*/\1/' | sed 's/^.*sunrise="\(.*m\)".*/\1/')" +%H%M)
            sunset=$(date -d"$(echo "$weather_data" | grep "yweather:astronomy" | sed 's/^.*sunset="\(.*m\)".*/\1/')" +%H%M)
        elif [ -f "${tmp_file}" ]; then
            __read_tmp_file
        fi
    fi

    if [ -n "$degree" ]; then
        condition_symbol=$(__get_condition_symbol "$condition" "$sunrise" "$sunset")
        echo "${condition_symbol} ${degree}°C" | tee "${tmp_file}"
    fi
}

# Get symbol for condition. Available conditions: http://developer.yahoo.com/weather/#codes
__get_condition_symbol() {
    local condition=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    local sunrise="$2"
    local sunset="$3"
    case "$condition" in
        "sunny" | "hot")
            hourmin=$(date +%H%M)
            if [ "$hourmin" -ge "$sunset" -o "$hourmin" -le "$sunrise" ]; then
                #echo "☽"
                echo "☾"
            else
                #echo "☀"
                echo "☼"
            fi ;;
        "rain" | "mixed rain and snow" | "mixed rain and sleet" | "freezing drizzle" | "drizzle" | "light drizzle" | "freezing rain" | "showers" | "mixed rain and hail" | "scattered showers" | "isolated thundershowers" | "thundershowers" | "light rain with thunder" | "light rain" | "rain and snow")
            #echo "☂"
            echo "☔" ;;
        "snow" | "mixed snow and sleet" | "snow flurries" | "light snow showers" | "blowing snow" | "sleet" | "hail" | "heavy snow" | "scattered snow showers" | "snow showers" | "light snow" | "snow/windy" | "snow grains" | "snow/fog")
            #echo "☃"
            echo "❅" ;;
        "cloudy" | "mostly cloudy" | "partly cloudy" | "partly cloudy/windy")
            echo "☁" ;;
        "tornado" | "tropical storm" | "hurricane" | "severe thunderstorms" | "thunderstorms" | "isolated thunderstorms" | "scattered thunderstorms")
            echo "⚡" ;;
        "dust" | "foggy" | "fog" | "haze" | "smoky" | "blustery" | "mist")
            #echo "♨"
            #echo "﹌"
            echo "〰" ;;
        "windy" | "fair/windy")
            #echo "⚐"
            echo "⚑" ;;
        "clear" | "fair" | "cold")
            hourmin=$(date +%H%M)
            if [ "$hourmin" -ge "$sunset" -o "$hourmin" -le "$sunrise" ]; then
                echo "☾"
            else
                echo "〇"
            fi ;;
        *)
            echo "?" ;;
    esac
}

__read_tmp_file() {
    if [ ! -f "$tmp_file" ]; then
        return
    fi
    cat "${tmp_file}"
    exit
}

run_segment

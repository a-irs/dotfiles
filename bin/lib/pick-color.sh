#!/usr/bin/env bash

killall compton &> /dev/null
gpick
compton -b

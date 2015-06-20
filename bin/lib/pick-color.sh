#!/usr/bin/env bash

killall compton &> /dev/null
colorgrab
compton -b

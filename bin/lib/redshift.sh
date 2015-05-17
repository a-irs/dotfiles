#!/usr/bin/env bash

set -e

pgrep -x redshift || redshift -l '48.7:13.0' -t '5800:3200' -m vidmode -r

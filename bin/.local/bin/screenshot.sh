#!/bin/sh

. utils.sh

check_deps "slurp grim"

slurp | grim -g - - | wl-copy

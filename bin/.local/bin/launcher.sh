#!/bin/sh

. utils.sh

check_deps "wofi"

wofi \
    --prompt "Run" \
    --show drun \
    --matching fuzzy \
    --no-actions

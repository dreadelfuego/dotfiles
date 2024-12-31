#!/bin/sh

. utils.sh

check_deps "wofi cut tr wtype wl-copy"

selected=$(wofi -i -p "Emoji" --dmenu --matching fuzzy < "$XDG_CACHE_HOME/emoji" | cut -d " " -f 1 | tr -d "\n")
[ -z "$selected" ] && exit 0

wtype "$selected"; wl-copy "$selected"

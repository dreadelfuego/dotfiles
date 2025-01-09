#!/bin/sh

. utils.sh

check_deps "wofi firefox"

selected="$(grep -v "^#\|^$" "$HOME/documents/data/bookmarks.txt" | wofi -i -p "Bookmarks" --dmenu --matching fuzzy)"
[ -z "$selected" ] && exit 0

if pgrep firefox; then
    firefox "$selected"
else
    setsid -f firefox "$selected"
fi

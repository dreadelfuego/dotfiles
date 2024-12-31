#!/bin/sh

selected="$(find "/usr/bin/" -type f | sort | fzf)"

[ -z "$selected" ] && exit 0

name="$(printf "man_%s" "${selected##*/}" | tr "." "_")"

if tmux lsw | grep -q ": $name"; then 
    tmux selectw -t "$name"
else
    tmux neww -n "$name" -c sh "man $selected"
fi

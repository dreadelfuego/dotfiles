#!/bin/sh

[ $# -eq 1 ] \
    && selected=$1 \
    || selected="$(find "$HOME"/repos -mindepth 1 -maxdepth 1 -type d | sort | fzf)"

[ -z "$selected" ] && exit 0

name="$(basename "$selected" | tr "." "_")"

tmux has-session -t "$name" 2> /dev/null || tmux new-session -ds "$name" -c "$selected"
tmux switch-client -t "$name"

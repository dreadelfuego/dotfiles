#!/bin/sh

selected=$(
    find "$HOME/.dotfiles" -type f ! -path "*.git/*" \
    | sort \
    | fzf --preview "bat --style=numbers --color=always {}"
)

[ -z "$selected" ] && exit 0

filepath=$selected
filename=$(echo "${selected#/*/*/}" | tr "/." "_")

if tmux lsw | grep -q ": $filename"; then
    tmux selectw -t "$filename"
else
    tmux neww -n "$filename" -c sh "nvim $filepath"
fi

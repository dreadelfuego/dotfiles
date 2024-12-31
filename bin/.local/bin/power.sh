#!/bin/sh

. utils.sh

check_deps "wofi systemctl"

selected=$(printf "Power Off\nReboot\nSleep\nLock\nLogout" | wofi -i -p "Power" --dmenu --matching fuzzy | tr "[:upper:]" "[:lower:]" | tr -d "[:space:]")
[ -z "$selected" ] && exit 0

case "$selected" in
    "poweroff") systemctl poweroff ;;
    "reboot") systemctl reboot ;;
    "sleep") hyprlock & systemctl suspend ;;
    "lock") hyprlock ;;
    "logout") loginctl terminate-user "$USER" ;;
    *) notify_and_exit "Power" "Invalid option" ;;
esac

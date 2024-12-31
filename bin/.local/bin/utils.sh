#!/bin/sh

notify() {
    summary="$1"
    body="$2"

    notify-send "$summary" "$body"
}

notify_and_exit() {
    summary="$1"
    body="$2"

    notify-send "$summary" "$body"
    exit 1
}

check_deps() {
    commands="$1"

    for command in ${commands}; do
        command -v "$command" > /dev/null \
            || notify_and_exit "Check Dependencies" "The command $command is not installed"
    done
}

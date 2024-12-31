#!/bin/sh

export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export GOPATH="$XDG_DATA_HOME/go"
export GOCACHE="$XDG_CACHE_HOME/go/mod"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"

export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PASSWORD_STORE_GENERATED_LENGTH=24
export PASSWORD_STORE_CLIP_TIME=15

export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite-history"
export PSQL_HISTORY=-

export LESSHISTFILE=-

export HYPRCURSOR_SIZE=24
export XCURSOR_SIZE=24

export EDITOR="nvim"

append_path () {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

append_path "$HOME/.local/bin"
append_path "$GOPATH/bin"

unset -f append_path

export PATH

[ "$(tty)" = /dev/tty1 ] && Hyprland

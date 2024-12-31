#!/bin/sh

. utils.sh

check_deps "curl jq"

curl "https://raw.githubusercontent.com/muan/emojilib/v4.0.0/dist/emoji-en-US.json" \
  | jq --raw-output '. | to_entries | .[] | .key + " " + (.value | join(" ") | sub("_"; " "; "g"))' \
  > "$XDG_CACHE_HOME"/emoji

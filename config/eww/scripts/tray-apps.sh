#!/bin/bash

declare -A APP_PROCESS=(
  [spotify]="spotify"
  [steam]="steam"
  [discord]="Discord"
  [telegram]="Telegram"
)

declare -A APP_CLASS=(
  [spotify]="Spotify"
  [steam]="steam"
  [discord]="discord"
  [telegram]="org.telegram.desktop"
)

json="["

first=true

for app in "${!APP_PROCESS[@]}"; do
    process="${APP_PROCESS[$app]}"
    class="${APP_CLASS[$app]}"

    if hyprctl clients | grep -q "class: $class"; then
        [ "$first" = true ] || json+=","
        first=false

        json+="{\"name\":\"$app\",\"class\":\"${APP_CLASS[$app]}\",\"icon\":\"${APP_CLASS[$app],,}\"}"
    fi
done

json+="]"

echo "$json"
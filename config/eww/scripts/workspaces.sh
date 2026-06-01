#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_workspaces() {
  active=$(hyprctl activeworkspace -j | jq -cr '.id')

  hyprctl workspaces -j | jq -c --argjson active "$active" '
    sort_by(.id) |
    map({
      id: .id,
      name: .name,
      active: (.id == $active)
    })
  '
}

get_workspaces

socat -U - UNIX-CONNECT:$SOCKET | while read -r line; do
  case "$line" in
    workspace*|createworkspace*|destroyworkspace*)
      get_workspaces
      ;;
  esac
done
#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

CACHE_DIR="$HOME/.config/eww/assets/applications"

mkdir -p "$CACHE_DIR"

get_icon() {
  class=$(hyprctl activewindow -j | jq -r '.class')

  # lowercase for cache naming
  class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')

  # search cache local
  cached_icon=$(find "$CACHE_DIR" \
    \( -iname "${class_lower}.svg" -o -iname "${class_lower}.png" \) \
    | head -n 1)

  if [ -n "$cached_icon" ]; then
    echo "$cached_icon"
    return
  fi

  # search desktop file
  desktop=$(find /usr/share/applications ~/.local/share/applications \
    -iname "*${class}*.desktop" | head -n 1)

  icon=""
  if [ -n "$desktop" ]; then
    icon=$(grep -m1 '^Icon=' "$desktop" | cut -d'=' -f2)
  fi

  if [ -z "$icon" ]; then
    icon="$class_lower"
  fi

  # search system icon
  system_icon=$(find /usr/share/icons ~/.local/share/icons /usr/share/pixmaps \
    -iname "*${icon}*" \
    | grep -Ei '\.(svg|png|xpm)$' \
    | grep -v symbolic \
    | head -n1)

  [ -z "$system_icon" ] && return

  # copy to local cache
  ext="${system_icon##*.}"

  cached_path="$CACHE_DIR/${class_lower}.${ext}"

  cp "$system_icon" "$cached_path"

  # return cache local
  echo "$cached_path"
}

get_icon

# listen for changes
socat -U - UNIX-CONNECT:$SOCKET | while read -r line; do
  case "$line" in
    activewindow*)
      get_icon
      ;;
  esac
done
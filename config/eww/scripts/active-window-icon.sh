#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

CACHE_DIR="$HOME/.config/eww/assets/applications"

mkdir -p "$CACHE_DIR"

get_icon() {
  class=$(hyprctl activewindow -j | jq -r '.class')

  # lowercase for cache naming
  class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')

  # ------------------------------------------------
  # 1. search cache local
  # ------------------------------------------------

  cached_icon=$(find "$CACHE_DIR" \
    \( -iname "${class_lower}.svg" -o -iname "${class_lower}.png" \) \
    | head -n 1)

  if [ -n "$cached_icon" ]; then
    echo "$cached_icon"
    return
  fi

  # ------------------------------------------------
  # 2. search desktop file
  # ------------------------------------------------

  desktop=$(find /usr/share/applications ~/.local/share/applications \
    -iname "*${class}*.desktop" | head -n 1)

  [ -z "$desktop" ] && return

  # ------------------------------------------------
  # 3. get icon name from desktop file
  # ------------------------------------------------

  icon=$(grep -m1 '^Icon=' "$desktop" | cut -d'=' -f2)

  [ -z "$icon" ] && return

  # ------------------------------------------------
  # 4. search system icon
  # ------------------------------------------------

  system_icon=$(find /usr/share/icons /usr/share/pixmaps \
    \( -iname "${icon}.svg" -o -iname "${icon}.png" \) \
    | head -n 1)

  [ -z "$system_icon" ] && return

  # ------------------------------------------------
  # 5. copy to local cache
  # ------------------------------------------------

  ext="${system_icon##*.}"

  cached_path="$CACHE_DIR/${class_lower}.${ext}"

  cp "$system_icon" "$cached_path"

  # ------------------------------------------------
  # 6. return cache local
  # ------------------------------------------------

  echo "$cached_path"
}

# initial fetch
get_icon

# listen for changes
socat -U - UNIX-CONNECT:$SOCKET | while read -r line; do
  case "$line" in
    activewindow*)
      get_icon
      ;;
  esac
done
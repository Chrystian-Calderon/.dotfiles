#!/bin/bash

DEFAULT_COVER="$HOME/.config/eww/assets/images/waguri-kaoruko.jpg"
PLAYER="spotify"

title=$(playerctl -p "$PLAYER" metadata xesam:title 2>/dev/null)
artist=$(playerctl -p "$PLAYER" metadata xesam:artist 2>/dev/null)
status=$(playerctl -p "$PLAYER" status 2>/dev/null)
url=$(playerctl -p "$PLAYER" metadata mpris:artUrl 2>/dev/null)
position=$(playerctl -p "$PLAYER" position 2>/dev/null)
length=$(playerctl -p "$PLAYER" metadata mpris:length 2>/dev/null)

length=$((length / 1000000))
CACHE_DIR="$HOME/.cache/eww/cover.jpg"

# descargar cover si es URL
if [[ "$url" == http* ]]; then
    curl -s "$url" -o "$CACHE_DIR"
    cover="$CACHE_DIR"
elif [[ "$url" == file://* ]]; then
    cover="${url#file://}"
else
    cover="$DEFAULT_COVER"
fi

echo "{
  \"title\": \"$title\",
  \"artist\": \"$artist\",
  \"status\": \"$status\",
  \"cover\": \"$cover\",
  \"position\": \"$position\",
  \"length\": \"$length\"
}"
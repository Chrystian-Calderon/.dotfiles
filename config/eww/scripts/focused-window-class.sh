#!/bin/bash

handle() {
  class=$(hyprctl activewindow -j | jq -r '.class')

  case "$class" in
    code|Code)
      echo "VSCode"
      ;;

    firefox)
      echo "Firefox"
      ;;

    kitty)
      echo "Kitty"
      ;;
    
    "brave-browser")
      echo "Brave"
      ;;

    "dev.warp.Warp")
      echo "Warp"
      ;;
    
    "org.kde.dolphin")
      echo "Dolphin"
      ;;
    
    "com.obsproject.Studio")
      echo "OBS"
      ;;
    
    "org.telegram.desktop")
      echo "Telegram"
      ;;

    *)
      echo "$class"
      ;;
  esac
}

handle

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock |
while read -r line; do
  case "$line" in
    activewindow*)
      handle
      ;;
  esac
done
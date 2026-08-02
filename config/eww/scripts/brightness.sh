#!/bin/bash

WINDOW="brightness-indicator-window"
PID_FILE="/tmp/eww-brightness-timer.pid"

case "$1" in
    up)
        brightnessctl set 5%+
        ;;

    down)
        brightnessctl set 5%-
        ;;

    *)
        exit 1
        ;;
esac

# open window if not open
eww open "$WINDOW"

# cancel previous timer
if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
fi

# create new timer
(
    sleep 2
    eww close "$WINDOW"
    rm -f "$PID_FILE"
) &

echo $! > "$PID_FILE"
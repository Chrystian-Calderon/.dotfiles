#!/bin/bash

WINDOW="volume-indicator-window"
PID_FILE="/tmp/eww-volume-timer.pid"

case "$1" in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        ;;

    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;

    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;

    *)
        exit 1
        ;;
esac

# Abrir la ventana si no está abierta
eww open "$WINDOW"

# Cancelar temporizador anterior
if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
fi

# Crear nuevo temporizador
(
    sleep 2
    eww close "$WINDOW"
    rm -f "$PID_FILE"
) &

echo $! > "$PID_FILE"
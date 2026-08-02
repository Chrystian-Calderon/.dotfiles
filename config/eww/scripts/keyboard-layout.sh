#!/bin/bash

layouts=$(hyprctl devices | grep "active keymap:" | sed 's/.*active keymap: //')

if echo "$layouts" | grep -q "^English (US)$"; then
    echo "US"
else
    echo "ES"
fi
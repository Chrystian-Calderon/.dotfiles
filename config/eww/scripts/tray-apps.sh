#!/bin/bash

apps=()

pgrep spotify >/dev/null && apps+=('"spotify"')
pgrep steam >/dev/null && apps+=('"steam"')
pgrep Discord >/dev/null && apps+=('"discord"')
pgrep telegram-desktop >/dev/null && apps+=('"telegram"')

printf '[%s]\n' "$(IFS=,; echo "${apps[*]}")"
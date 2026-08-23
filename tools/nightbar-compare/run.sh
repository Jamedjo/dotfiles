#!/bin/sh
# Render both sides and compare. The design is rebuilt at the live panel width
# with the live readings, so only the design differs.
set -u
C=/home/james/dotfiles/tools/nightbar-compare
B=/tmp/claude-1000/-home-james-dotfiles/d7d55534-b966-4c8e-940b-3d44a7c2fb35/scratchpad/build
cd "$C"

python3 mkref.py "$@" >/dev/null
timeout 120 google-chrome --headless --disable-gpu --no-sandbox --hide-scrollbars \
    --force-device-scale-factor=1 --window-size=520,1400 \
    --screenshot="$C/ref-raw.png" "$C/ref.html" >/dev/null 2>&1
python3 prep.py ref-raw.png ref.png design

"$B/shoot-panel.sh" >/dev/null 2>&1 || true
# the control centre is 460px wide against the right edge, under the 34px bar
python3 prep.py "$B/panel.png" impl.png built --right --top 34

#!/bin/sh
# Render the design's bar beside the built one.
#
# Same registration as run.sh: the design is rebuilt with the modules waybar
# actually has, in the order waybar has them, at waybar's own geometry, so a
# module in one image is the same module in the other.
#
# The built side comes from bar-mock.sh -- a headless sway with a waybar of its
# own. His session is never touched, and never should be: reload_style_on_change
# means writing style.css already restyles his live bar, which is exactly why
# the mock has to be right first.
set -u
C=$(cd "$(dirname "$0")" && pwd)
W=${NIGHTBAR_MOCK:-${XDG_RUNTIME_DIR:-/tmp}/nightbar-mock}
cd "$C"

python3 mkbar.py "$@" >/dev/null
timeout 120 google-chrome --headless --disable-gpu --no-sandbox --hide-scrollbars \
    --force-device-scale-factor=1 --window-size=1920,60 \
    --screenshot="$C/bar-ref.png" "$C/bar.html" >/dev/null 2>&1

[ -f "$W/shot.png" ] || ./bar-mock.sh start >/dev/null
./bar-mock.sh shoot >/dev/null
python3 barsheet.py "$W/shot.png"

#!/bin/sh
# Stand up a headless sway with a waybar of its own, and photograph the bars.
#
# Never the live session. His compositor and his waybar are left alone: this
# starts its own sway on the headless backend, gives it his gaps, borders and
# client colours, and runs waybar against a COPY of his config with every
# custom module stubbed -- switchboard, notification, focuslock and todoist all
# shell out to his real state otherwise.
#
#   ./bar-mock.sh start     bring it up, capture to $W/shot.png
#   ./bar-mock.sh shoot     restart the mock waybar and capture again
#   ./bar-mock.sh stop      take it down
#
# style.css is read live, so the loop is: edit, ./bar-mock.sh shoot, look.
set -u
C=$(cd "$(dirname "$0")" && pwd)
W=${NIGHTBAR_MOCK:-${XDG_RUNTIME_DIR:-/tmp}/nightbar-mock}
mkdir -p "$W"

WS='1:meetings 2:email 3:slack 4:todos 5:scratch 7:chief:v2-review 9:family:someone'
ACTIVE=7:chief:v2-review

sway_env() {
    SWAYPID=$(cat "$W/sway.pid" 2>/dev/null) || return 1
    export SWAYSOCK="/run/user/$(id -u)/sway-ipc.$(id -u).$SWAYPID.sock"
    export WAYLAND_DISPLAY=$(cat "$W/wldisplay")
    # Never chain this with && -- if the mock is gone we must not fall through
    # to whatever swaymsg would find instead.
    swaymsg -t get_outputs | grep -q HEADLESS-1 || {
        echo "no HEADLESS-1: refusing to drive a session that is not the mock" >&2
        exit 1
    }
}

start() {
    cat > "$W/sway.conf" <<EOF
output HEADLESS-1 resolution 1920x1200 bg $HOME/dotfiles/wallpapers/chief-navy-1920x1200.png fill
gaps inner 8
gaps outer 3
smart_gaps off
smart_borders on
hide_edge_borders --i3 both
focus_follows_mouse no
default_border normal 1
default_floating_border normal 1
font pango:Inter Medium 10
titlebar_padding 12 5
client.focused          #2f7ff0   #2f7ff0   #ffffff #5aa6ff   #1c498a
client.focused_inactive #182f52   #0c1c36   #94abcd #182f52   #12294a
client.unfocused        #12294a   #081222   #5f769a #12294a   #12294a
client.urgent           #ffb14d   #0c1c36   #ffb14d #ffb14d   #ffb14d
exec sh -c 'printenv WAYLAND_DISPLAY > $W/wldisplay'
EOF
    rm -f "$W/wldisplay"
    env -u WAYLAND_DISPLAY -u SWAYSOCK -u DISPLAY WLR_BACKENDS=headless \
        WLR_LIBINPUT_NO_DEVICES=1 sway --unsupported-gpu -c "$W/sway.conf" \
        > "$W/sway.log" 2>&1 &
    echo $! > "$W/sway.pid"
    sleep 3
    sway_env
    # An empty workspace is destroyed the moment focus leaves it, so each one
    # that should appear on the bar needs a window parked on it.
    for w in $WS; do
        swaymsg workspace "$w" >/dev/null
        swaymsg exec "foot -T ws-holder -- sleep 100000" >/dev/null
        sleep 0.7
    done
    swaymsg workspace "$ACTIVE" >/dev/null
    sleep 1
    shoot
}

shoot() {
    sway_env
    python3 "$C/bar-stub.py" "$W/config.mock"
    [ -f "$W/waybar.pid" ] && kill "$(cat "$W/waybar.pid")" 2>/dev/null
    sleep 1
    setsid waybar -c "$W/config.mock" -s "${NIGHTBAR_STYLE:-$HOME/.config/waybar/style.css}" \
        > "$W/waybar.log" 2>&1 &
    echo $! > "$W/waybar.pid"
    sleep 4
    grim -o HEADLESS-1 "$W/shot.png"
    echo "$W/shot.png"
}

stop() {
    [ -f "$W/waybar.pid" ] && kill "$(cat "$W/waybar.pid")" 2>/dev/null
    [ -f "$W/sway.pid" ] && kill "$(cat "$W/sway.pid")" 2>/dev/null
    rm -f "$W/waybar.pid" "$W/sway.pid"
    echo "mock down"
}

case "${1:-shoot}" in
    start) start ;;
    shoot) shoot ;;
    stop)  stop  ;;
    *) echo "usage: $0 start|shoot|stop" >&2; exit 2 ;;
esac

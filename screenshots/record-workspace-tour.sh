#!/bin/sh
# Re-record workspace-tour.mp4 by driving the real pickers on the live session.
#
# What it films: creating a workspace by typing its name, opening a window,
# sending it to a second typed-into-existence workspace, switching by
# fragment, promoting into slot 2, renaming, the AI icon arriving, and a
# final look at the MRU picker. Everything it creates is torn down after.
#
# Privacy: workspaces whose label starts with $PRIVATE_PREFIX are renamed to
# the prefix alone while the camera rolls, and renamed back after.
#
# Requires:
#   wtype        keystroke injection; not packaged for noble, build to ~/.local/bin:
#                  git clone https://github.com/atx/wtype
#                  cd wtype && meson setup build && ninja -C build
#                  install -m755 build/wtype ~/.local/bin/
#   wf-recorder  packaged; records via the Intel iGPU like Shift+Print does
#   ffmpeg + imagemagick   poster frame
#
# fuzzel closes when the seat's keyboard focus blinks, and a virtual keyboard
# appearing is exactly such a blink, so exit-on-keyboard-focus-loss is turned
# off for the duration. sed -i severs the config's hard link into the repo,
# which is what makes the restore trivial: the repo copy still says =yes and
# ln -f puts it back.
set -u

REPO=$(cd "$(dirname "$0")/.." && pwd)
OUT="$REPO/screenshots/workspace-tour.mp4"
POSTER="$REPO/screenshots/workspace-tour-poster.png"
S="$HOME/.config/sway/scripts"
FUZZEL_CFG="$HOME/.config/fuzzel/sway-menu.ini"
NAMES_STORE="${XDG_STATE_HOME:-$HOME/.local/state}/sway-workspace-names"
ICONS="$HOME/.config/waybar/workspace-icons.json"
PRIVATE_PREFIX="family"
STATE=$(mktemp -d)

type() { wtype -d 160 "$1"; }
key()  { wtype -k "$1"; }
ws()   { swaymsg -t get_workspaces; }

command -v wtype >/dev/null || { echo "wtype missing; see header" >&2; exit 1; }

# --- stage ------------------------------------------------------------------
ws | jq -r '.[] | select(.focused) | .name' > "$STATE/prev-ws"
ws | jq -r '.[] | select(.num == 2) | .name' > "$STATE/slot2"

# The names daemon restores whatever the store last saw on slot 18, and a
# previous take parks the old slot-2 occupant there -- without this the
# "empty" starting workspace comes up wearing that name on camera.
sed -i '/^18\t/d' "$NAMES_STORE" 2>/dev/null

# Private workspaces go incognito: "17:family:someone" -> "17:family".
ws | jq -r --arg p "$PRIVATE_PREFIX" \
    '.[] | select((.name | split(":")[1:] | join(":")) | startswith($p + ":")) | .name' \
    > "$STATE/private"
while IFS= read -r name; do
    num=${name%%:*}
    swaymsg rename workspace "$name" to "$num:$PRIVATE_PREFIX" >/dev/null
done < "$STATE/private"

# The stand-in label borrows the real workspace's icon so the bar does not
# show a bare, iconless name on camera. Removed again in the teardown.
orig=$(head -1 "$STATE/private")
if [ -n "$orig" ]; then
    from=${orig#*:}
    jq --arg from "$from" --arg to "$PRIVATE_PREFIX" \
        'if ."sway/workspaces"."format-icons"[$from]
         then ."sway/workspaces"."format-icons"[$to] = ."sway/workspaces"."format-icons"[$from]
         else . end' "$ICONS" > "$STATE/icons-pre" && cat "$STATE/icons-pre" > "$ICONS"
    "$S/sway-waybar" >/dev/null 2>&1 &
    sleep 1
fi

sed -i 's/^exit-on-keyboard-focus-loss=yes/exit-on-keyboard-focus-loss=no/' "$FUZZEL_CFG"

# --- roll -------------------------------------------------------------------
# Switch to the staging workspace BEFORE the recorder starts: the first frames
# are otherwise whatever was on screen, which is private by default.
swaymsg workspace number 18 >/dev/null
sleep 1

wf-recorder -g "0,0 1920x1200" -f "$OUT" -c h264_vaapi -d /dev/dri/renderD129 \
    -p profile=high -p qp=20 >/dev/null 2>&1 &
REC=$!
sleep 2
"$S/sway-ws-switch" & sleep 1.6; type 'demo-blog'; sleep 1.2; key Return; sleep 2.2
foot & sleep 2.2
"$S/sway-ws-move"   & sleep 1.6; type 'demo-notes'; sleep 1.2; key Return; sleep 2.2
"$S/sway-ws-switch" & sleep 1.6; type 'notes'; sleep 1; key Return; sleep 2.2
"$S/sway-ws-promote" 2; sleep 3
"$S/sway-ws-rename" & sleep 1.6; type 'demo-launch'; sleep 1; key Return; sleep 2.5
sleep 14                                    # background icon picks + bar reload
"$S/sway-ws-switch" & sleep 2.8; key Escape; sleep 1.2

kill -INT $REC; wait $REC 2>/dev/null

# --- tear down --------------------------------------------------------------
# Demo windows first, so the demo workspaces evaporate once unfocused.
swaymsg -t get_tree | jq -r '
    recurse(.nodes[]?, .floating_nodes[]?)
    | select(.type? == "workspace" and (.name | test("demo")))
    | recurse(.nodes[]?, .floating_nodes[]?)
    | select(.name? != null and .type? == "con") | .id' \
| while read -r id; do swaymsg "[con_id=$id] kill" >/dev/null; done

# Hand slot 2 back to whoever held it; the demo squatter parks and dies empty.
old2=$(cat "$STATE/slot2")
if [ -n "$old2" ]; then
    label2=${old2#*:}
    cur=$(ws | jq -r --arg l "$label2" '.[] | select((.name | endswith(":" + $l))) | .name' | head -1)
    [ -n "$cur" ] && swaymsg workspace "$cur" >/dev/null && "$S/sway-ws-promote" 2
fi

sed -i '/\tdemo-/d' "$NAMES_STORE" 2>/dev/null
# Truncate-in-place keeps the icon file's hard link into the repo.
jq --arg to "$PRIVATE_PREFIX" \
   'del(."sway/workspaces"."format-icons"."demo-blog",
        ."sway/workspaces"."format-icons"."demo-notes",
        ."sway/workspaces"."format-icons"."demo-launch",
        ."sway/workspaces"."format-icons"[$to])' "$ICONS" > "$STATE/icons" \
    && cat "$STATE/icons" > "$ICONS"

ln -f "$REPO/fuzzel/sway-menu.ini" "$FUZZEL_CFG"

while IFS= read -r name; do
    num=${name%%:*}
    swaymsg rename workspace "$num:$PRIVATE_PREFIX" to "$name" >/dev/null 2>&1
done < "$STATE/private"

"$S/sway-waybar" >/dev/null 2>&1 &
sleep 1
swaymsg workspace "$(cat "$STATE/prev-ws")" >/dev/null

# --- poster -----------------------------------------------------------------
# The last thing filmed is the MRU picker sitting open, so cut the poster a
# beat before the end rather than at a fixed offset that drifts per take.
D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT")
ffmpeg -v error -ss "$(awk "BEGIN {print $D - 2.8}")" -i "$OUT" -frames:v 1 -y "$STATE/poster.png"
convert "$STATE/poster.png" -resize 1280x -gravity center \
    \( -size 160x160 xc:none -fill '#0f1f38d0' -draw 'circle 80,80 80,10' \
       -fill white -draw 'polygon 62,45 62,115 122,80' \) \
    -composite "$POSTER"

rm -rf "$STATE"
echo "recorded $OUT"

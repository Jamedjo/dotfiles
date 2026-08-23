#!/usr/bin/env python3
"""Stack the design's bar over the built one, and measure the bottom edge.

The picture is for the eye; the number under it is the one that has caught a
regression twice. waybar's window is exactly the bar height, so a shadow or a
glow larger than the card's margin is cropped by the window edge, and a crop
reads as a hard line drawn under the bar. `step` is how far the bar's last row
is from the desktop below it: single digits are a fade, forty is a line.

  python3 barsheet.py shot.png                 both clusters, x3
  python3 barsheet.py shot.png --at 0 340 5    one crop, magnified
"""
import argparse, pathlib
from PIL import Image, ImageDraw
import numpy as np

AP = argparse.ArgumentParser()
AP.add_argument("built", help="grim capture of the headless bar, full output")
AP.add_argument("--ref", default="bar-ref.png")
AP.add_argument("--at", nargs=3, type=int, metavar=("X0", "X1", "ZOOM"))
AP.add_argument("--height", type=int, default=34, help="the bar window's height")
AP.add_argument("--out", default="bar-sheet.png")
a = AP.parse_args()

ref = Image.open(a.ref).convert("RGB")
imp = Image.open(a.built).convert("RGB")

crops = [tuple(a.at)] if a.at else [(0, 360, 3), (1380, 1920, 3)]
tiles = []
for x0, x1, z in crops:
    w, h = x1 - x0, a.height + 6
    t = Image.new("RGB", (w, h * 2 + 14), (7, 12, 22))
    t.paste(ref.crop((x0, 0, x1, h)), (0, 0))
    t.paste(imp.crop((x0, 0, x1, h)), (0, h + 14))
    t = t.resize((w * z, (h * 2 + 14) * z), Image.NEAREST)
    d = ImageDraw.Draw(t)
    d.text((4, h * z + 2), "design above, build below", fill=(120, 150, 190))
    tiles.append(t)

sheet = Image.new("RGB", (max(t.width for t in tiles),
                          sum(t.height + 8 for t in tiles)), (7, 12, 22))
y = 0
for t in tiles:
    sheet.paste(t, (0, y)); y += t.height + 8
sheet.save(a.out)

# The edge: the bar's last row against the desktop below it, less the same
# reading taken entirely on the desktop. The wallpaper has a gradient of its
# own, and without subtracting it the wallpaper's brightest band scores higher
# than a real crop does.
px = np.asarray(imp).astype(int)
h = a.height
jump = np.abs(px[h - 1] - px[h + 2]).sum(1)
desk = np.abs(px[h + 2] - px[h + 5]).sum(1)
step = np.clip(jump - desk, 0, None)
print(f"{a.out}: {len(crops)} crop(s)")
print(f"bottom-row step: max {step.max()} at x={step.argmax()}, mean {step.mean():.1f}")

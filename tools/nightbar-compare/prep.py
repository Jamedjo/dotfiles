#!/usr/bin/env python3
"""Cut both sides down to just the panel, at 1:1 pixels.

Registration is the whole game: the design is rendered at the live panel width
so a band in one image is the same band in the other, and neither is rescaled.

Finding the panel in a full-screen capture took three goes. Brightness alone
truncates it, because the notification card is darker than the wallpaper behind
it. control-center-width is not the painted width either -- the surface carries
margin. So the left edge is measured on a probe row near the top, and the panel
then runs down as far as that edge keeps stepping.
"""
import sys, argparse, numpy as np
from PIL import Image

ap = argparse.ArgumentParser()
ap.add_argument("src"); ap.add_argument("out"); ap.add_argument("label")
ap.add_argument("--right", action="store_true", help="panel is against the right edge")
ap.add_argument("--top", type=int, default=0, help="first row below the bar")
a = ap.parse_args()

im = Image.open(a.src).convert("RGB")
rgb = np.asarray(im).astype(int)
lum = rgb.sum(2)

if not a.right:
    desk = np.percentile(lum, 5)
    lit = lum > desk + 26
    cols = np.nonzero(lit.sum(0) > 40)[0]
    rows = np.nonzero(lit.sum(1) > 40)[0]
    im.crop((cols.min(), rows.min(), cols.max() + 1, rows.max() + 1)).save(a.out)
    o = Image.open(a.out)
    print(f"{a.label:6} {a.out}  {o.width}x{o.height}")
    sys.exit()

# The left edge is taken from swaync's configured width plus a little slack,
# not hunted for. Hunting it meant sampling "the wallpaper" somewhere to the
# left, and in a mock with windows open that sample is a window: the scan then
# ran past the panel and took half the screen with it. A few columns of desk on
# the left cost nothing, since bands are found by content.
x0 = max(0, im.width - 476)

# The bottom edge is not hunted for. Three attempts at it all truncated the
# panel somewhere different, because the notification card is darker than the
# panel above it and close to the wallpaper behind it. A generous fixed height
# costs nothing: compare.py finds bands by content, and empty desk below the
# panel produces none.
top = a.top
end = min(im.height, top + 900)
out = im.crop((x0, top, im.width, end))
out.save(a.out)
print(f"{a.label:6} {a.out}  {out.width}x{out.height}  (x {x0}-{im.width}, y {top}-{end})")

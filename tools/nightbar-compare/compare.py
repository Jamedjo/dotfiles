#!/usr/bin/env python3
"""Compare a rendered surface against Vale's design and say where it drifts.

Both sides are rendered at the same panel width, so a region in one lines up
with the same region in the other. The useful output is not the picture: it is
the ranked table of which band differs most, and by what -- height, ink
coverage, or colour.

  compare.py regions            list the bands found on each side
  compare.py sheet              side by side per band, plus a difference map
  compare.py zoom <band>        one band, magnified, ref beside impl
  compare.py tokens             sampled colours against nightbar.css tokens
"""
import sys, re, json, pathlib
import numpy as np
from PIL import Image, ImageDraw, ImageFont

REF  = "ref.png"
IMPL = "impl.png"

def font(sz):
    try: return ImageFont.truetype("/home/james/.local/share/fonts/Inter[opsz,wght].ttf", sz)
    except Exception: return ImageFont.load_default()

def load(p):
    im = Image.open(p).convert("RGB")
    return im, np.asarray(im).astype(int)

def panel_bounds(a):
    """The panel is everything brighter than the desk it sits on."""
    lum = a.sum(2)
    bg = np.median(lum[:6, :])                      # desk colour from the top edge
    mask = lum > bg + 24
    ys, xs = np.nonzero(mask)
    if not len(ys): return (0, 0, a.shape[1], a.shape[0])
    return (xs.min(), ys.min(), xs.max() + 1, ys.max() + 1)

def bands(a, min_gap=10, thresh=0.02):
    """Rows carrying content differ from their own median; the ground does not.

    A plain variance threshold split single elements in two and merged
    neighbours, because the panel's ground is itself a gradient. Counting how
    much of each row departs from that row's own median is stable against it.
    """
    lum = a.sum(2)
    med = np.median(lum, axis=1, keepdims=True)
    frac = (np.abs(lum - med) > 40).mean(axis=1)
    k = 3
    frac = np.convolve(frac, np.ones(k) / k, mode="same")
    on = frac > thresh
    out, start = [], None
    for y, v in enumerate(on):
        if v and start is None: start = y
        elif not v and start is not None:
            if y - start >= 3: out.append((start, y))
            start = None
    if start is not None: out.append((start, len(on)))
    merged = []
    for b in out:
        if merged and b[0] - merged[-1][1] < min_gap:
            merged[-1] = (merged[-1][0], b[1])
        else: merged.append(list(b))
    return [tuple(m) for m in merged]

NAMES = ["head", "gauges", "toggles", "actions", "sliders", "notifications", "extra"]

def analyse(path):
    im, a = load(path)
    x0, y0, x1, y1 = panel_bounds(a)
    crop = a[y0:y1, x0:x1]
    bs = bands(crop)
    return im, a, (x0, y0, x1, y1), crop, bs

def describe(crop, b):
    seg = crop[b[0]:b[1]]
    lum = seg.sum(2)
    bg = np.median(lum)
    ink = float((np.abs(lum - bg) > 40).mean())
    return dict(y=b[0], h=b[1] - b[0], ink=ink,
                mean=tuple(seg.reshape(-1, 3).mean(0).round().astype(int)))

def cmd_regions():
    for path in (REF, IMPL):
        im, a, box, crop, bs = analyse(path)
        print(f"\n{path}  panel {box[2]-box[0]}x{box[3]-box[1]} at {box[0]},{box[1]}")
        for i, b in enumerate(bs):
            d = describe(crop, b)
            nm = NAMES[i] if i < len(NAMES) else f"band{i}"
            print(f"  {nm:14} y={d['y']:4}  h={d['h']:3}  ink={d['ink']:.3f}  mean={d['mean']}")

def paired():
    """Match bands by order and report per-band deltas, worst first."""
    rows = []
    _, _, _, rc, rb = analyse(REF)
    _, _, _, ic, ib = analyse(IMPL)
    for i in range(max(len(rb), len(ib))):
        nm = NAMES[i] if i < len(NAMES) else f"band{i}"
        r = describe(rc, rb[i]) if i < len(rb) else None
        m = describe(ic, ib[i]) if i < len(ib) else None
        if r is None or m is None:
            rows.append((nm, r, m, 999.0, "present on one side only")); continue
        dh = abs(r["h"] - m["h"])
        dink = abs(r["ink"] - m["ink"])
        dcol = float(np.abs(np.array(r["mean"]) - np.array(m["mean"])).mean())
        score = dh / 4.0 + dink * 60 + dcol / 3.0
        note = []
        if dh > 6:   note.append(f"height {r['h']}->{m['h']}")
        if dink > .05: note.append(f"ink {r['ink']:.2f}->{m['ink']:.2f}")
        if dcol > 8: note.append(f"colour {r['mean']}->{m['mean']}")
        rows.append((nm, r, m, score, "; ".join(note) or "close"))
    rows.sort(key=lambda x: -x[3])
    return rows, rc, rb, ic, ib

def accepted():
    p = pathlib.Path("accepted.json")
    if not p.exists(): return {}
    return {k: v for k, v in json.loads(p.read_text()).items() if not k.startswith("_")}

def cmd_sheet():
    rows, rc, rb, ic, ib = paired()
    acc = accepted()
    print(f"{'band':14} {'score':>7}  what drifted")
    for nm, r, m, s, note in rows:
        known = acc.get(nm)
        flag = "  (has accepted deviations)" if known else ""
        print(f"{nm:14} {s:7.1f}  {note}{flag}")
    if acc:
        print("\naccepted, so not drift:")
        for nm, reasons in acc.items():
            for why in reasons:
                print(f"  {nm:14} {why}")
    ref_im = Image.open(REF).convert("RGB"); impl_im = Image.open(IMPL).convert("RGB")
    f = font(15); pad, head = 12, 24
    W = max(ref_im.width, impl_im.width)
    tiles = []
    for i, (nm, r, m, s, note) in enumerate(sorted(rows, key=lambda x: NAMES.index(x[0]) if x[0] in NAMES else 99)):
        if r is None or m is None: continue
        rb_i = NAMES.index(nm) if nm in NAMES else i
        a = ref_im.crop((0, r["y"], ref_im.width, r["y"] + r["h"]))
        b = impl_im.crop((0, m["y"], impl_im.width, m["y"] + m["h"]))
        h = max(a.height, b.height)
        t = Image.new("RGB", (W * 2 + pad * 3, h + head), (7, 12, 22))
        d = ImageDraw.Draw(t)
        d.text((pad, 4), f"{nm}   design", fill=(166, 195, 232), font=f)
        d.text((W + pad * 2, 4), f"{nm}   built   [{note}]", fill=(200, 150, 120), font=f)
        t.paste(a, (pad, head)); t.paste(b, (W + pad * 2, head))
        tiles.append(t)
    H = sum(t.height + 8 for t in tiles)
    sheet = Image.new("RGB", (tiles[0].width, H), (7, 12, 22)); y = 0
    for t in tiles: sheet.paste(t, (0, y)); y += t.height + 8
    sheet.save("sheet.png"); print("\nwrote sheet.png", sheet.size)

def cmd_zoom(name, scale=3):
    rows, rc, rb, ic, ib = paired()
    hit = [r for r in rows if r[0] == name]
    if not hit: sys.exit(f"no band called {name}; try: {' '.join(NAMES)}")
    nm, r, m, s, note = hit[0]
    ref_im = Image.open(REF).convert("RGB"); impl_im = Image.open(IMPL).convert("RGB")
    a = ref_im.crop((0, r["y"], ref_im.width, r["y"] + r["h"]))
    b = impl_im.crop((0, m["y"], impl_im.width, m["y"] + m["h"]))
    h = max(a.height, b.height); W = max(a.width, b.width)
    f = font(13 * scale // 2); head = 22 * scale // 2
    out = Image.new("RGB", (W * scale, h * scale * 2 + head * 3), (7, 12, 22))
    d = ImageDraw.Draw(out)
    d.text((6, 4), f"{nm}: design", fill=(166, 195, 232), font=f)
    out.paste(a.resize((a.width * scale, a.height * scale), Image.NEAREST), (0, head))
    d.text((6, head + h * scale + 6), f"{nm}: built   [{note}]", fill=(200, 150, 120), font=f)
    out.paste(b.resize((b.width * scale, b.height * scale), Image.NEAREST), (0, head * 2 + h * scale))
    out.save(f"zoom-{nm}.png"); print(f"wrote zoom-{nm}.png", out.size)

def cmd_tokens():
    css = pathlib.Path("nightbar.css").read_text()
    toks = dict(re.findall(r'--(nb-[\w-]+):\s*(#[0-9a-fA-F]{6})', css))
    _, ia, box, ic, ib = analyse(IMPL)
    print(f"{len(toks)} colour tokens in nightbar.css")
    px = ic.reshape(-1, 3)
    for name, hexv in sorted(toks.items()):
        want = np.array([int(hexv[i:i+2], 16) for i in (1, 3, 5)])
        dist = np.abs(px - want).sum(1)
        n = int((dist < 18).sum())
        near = px[dist.argmin()]
        print(f"  {name:16} {hexv}  exact-ish px: {n:7}   closest present: "
              f"#{near[0]:02x}{near[1]:02x}{near[2]:02x}")

def cmd_crop(name, rspec, ispec, scale=2):
    """Compare two explicit y ranges, for when the bands no longer line up."""
    ry0, ry1 = (int(v) for v in rspec.split(":"))
    iy0, iy1 = (int(v) for v in ispec.split(":"))
    a = Image.open(REF).convert("RGB").crop((0, ry0, Image.open(REF).width, ry1))
    b = Image.open(IMPL).convert("RGB").crop((0, iy0, Image.open(IMPL).width, iy1))
    W = max(a.width, b.width); f = font(13)
    head = 20
    out = Image.new("RGB", (W * scale, (a.height + b.height) * scale + head * 3), (7, 12, 22))
    d = ImageDraw.Draw(out)
    d.text((6, 4), f"{name}: design  y{ry0}-{ry1}", fill=(166, 195, 232), font=f)
    out.paste(a.resize((a.width * scale, a.height * scale), Image.NEAREST), (0, head))
    y2 = head * 2 + a.height * scale
    d.text((6, y2 - head + 4), f"{name}: built  y{iy0}-{iy1}", fill=(200, 150, 120), font=f)
    out.paste(b.resize((b.width * scale, b.height * scale), Image.NEAREST), (0, y2))
    out.save(f"crop-{name}.png")
    print(f"wrote crop-{name}.png  design {a.width}x{a.height}  built {b.width}x{b.height}")

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "sheet"
    if cmd == "regions": cmd_regions()
    elif cmd == "sheet": cmd_sheet()
    elif cmd == "zoom":  cmd_zoom(sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 3)
    elif cmd == "tokens": cmd_tokens()
    elif cmd == "crop":
        cmd_crop(sys.argv[2], sys.argv[3], sys.argv[4],
                 int(sys.argv[5]) if len(sys.argv) > 5 else 2)
    else: sys.exit(__doc__)

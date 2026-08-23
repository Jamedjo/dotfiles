#!/usr/bin/env python3
"""Render Vale's bar at the implementation's real geometry.

Same trick as mkref.py, turned on its side: the panel is a stack of bands and
the bar is a row of items, so registration here means building the design's
`.nb-bar` out of the modules waybar actually has, in the order waybar has them,
against the same desk. What is left over is a difference in the design.

Two deviations are built in on purpose, because they are the layout James
chose rather than drift (see accepted.json, "bar"): the clock stands outside
the card at 21px, and the readouts sit in one card with the launcher.

  python3 mkbar.py --out bar.html
  python3 mkbar.py --active 3 --ws "1:meetings,2:email,..."
"""
import argparse, pathlib, html

# The bar's own glyphs, straight out of the live configs, so the reference is
# set in the same Nerd Font the build resolves to.
WS_GLYPH = {"meetings": "\uf03d", "email": "\uf0e0", "slack": "\uf198",
            "todos": "\uf046", "chief:v2-review": "\uf126",
            "family:someone": "\uf0c0"}
STAT = [("\uf0e8", "Chief > V2 Review"), ("\ufa7f", "60%"),
        ("\ufaa8", ""), ("\uf0e7", "91%")]
LAUNCH = "\uf1de"

AP = argparse.ArgumentParser()
AP.add_argument("--width", type=int, default=1920, help="output width")
AP.add_argument("--ws", default="1:meetings,2:email,3:slack,4:todos,"
                                "7:chief:v2-review,9:family:someone")
AP.add_argument("--active", default="7")
AP.add_argument("--clock", default="22:00")
AP.add_argument("--out", default="bar.html")
a = AP.parse_args()

CSS = pathlib.Path("nightbar.css").read_text()

items = []
for spec in a.ws.split(","):
    num, name = spec.split(":", 1)
    on = " nb-ws--active" if num == a.active else ""
    items.append(f'<div class="nb-ws{on}"><span class="nb-ws__n">{num}</span>'
                 f'<span class="nb-ws__icon">{WS_GLYPH.get(name, "")}</span></div>')

stats = "".join(
    f'<div class="nb-bar__stat"><span class="nb-icon">{ic}</span>'
    f'{html.escape(txt)}</div>' for ic, txt in STAT)

doc = f'''<!doctype html><meta charset=utf-8>
<style>
{CSS}
body {{ margin:0; padding:0; background:var(--nb-desk); width:{a.width}px; }}
/* waybar's own frame: the bar window is 34px tall and the card floats 5px
   inside it, 8px from the screen edge. */
.bar-row {{ height:34px; display:flex; align-items:center;
            justify-content:space-between; padding:0 8px; box-sizing:border-box; }}
.right {{ display:flex; align-items:center; gap:10px; }}
/* Chrome has no fontconfig fallback into the PUA, so every Nerd glyph would
   come out a tofu box unless the family is named on the node that draws it. */
.nb-ws__icon, .nb-icon, .nb-bar__launch {{ font-family:"Ubuntu Nerd Font"; }}
/* deviation, deliberate: James's clock is the one figure on the bar you read
   from across the room, so it stands outside the card at twice the size. */
.big-clock {{ font:700 21px/1 Inter, sans-serif; font-feature-settings:"tnum";
              letter-spacing:-.02em; color:var(--nb-ink); }}
</style>
<div class="bar-row">
  <div class="nb-bar">{"".join(items)}</div>
  <div class="right">
    <div class="nb-bar">
      <div class="nb-bar__group">{stats}
        <div class="nb-bar__launch">{LAUNCH}</div>
      </div>
    </div>
    <div class="big-clock">{a.clock}</div>
  </div>
</div>
'''
pathlib.Path(a.out).write_text(doc)
print(f"{a.out}: {a.width}px, active {a.active}")

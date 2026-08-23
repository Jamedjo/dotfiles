#!/usr/bin/env python3
"""Render Vale's design at the implementation's real geometry.

The point is to make the two directly comparable: the design's panel is 400px
and swaync's is 460, so the reference is rebuilt at the live width and fed the
same readings the live capture had. Everything left over after that is a
difference in the design, not in the data.
"""
import argparse, pathlib, html

AP = argparse.ArgumentParser()
AP.add_argument("--width", type=int, default=460)
AP.add_argument("--pad", type=int, default=16)
AP.add_argument("--clock", default="20:18")
AP.add_argument("--date", default="SUN 23 AUG")
AP.add_argument("--gauges", default="8:CPU:%,72:MEM:%,64:TEMP:°")
AP.add_argument("--toggles", default="1,0,0,1,0")
AP.add_argument("--actions", default="Shot,Colour,Focus,Rename,Lock,Keys")
AP.add_argument("--vol", type=int, default=55)
AP.add_argument("--bri", type=int, default=97)
AP.add_argument("--out", default="ref.html")
a = AP.parse_args()

CSS = pathlib.Path("nightbar.css").read_text()

gauges = []
for spec in a.gauges.split(","):
    val, cap, unit = spec.split(":")
    warn = " nb-gauge--warn" if int(val) >= 90 else ""
    gauges.append(f'''
      <div class="nb-gauge{warn}">
        <div class="nb-gauge__ring" style="--nb-pct:{val}%">
          <div class="nb-gauge__well">
            <div><span class="nb-gauge__val">{val}</span><span class="nb-gauge__unit">{unit}</span></div>
          </div>
        </div>
        <div class="nb-gauge__label">{cap}</div>
      </div>''')

TOG = ["&#8776;", "&#7517;", "&#9788;", "&#9790;", "&#8856;"]
toggles = "".join(
    f'<div class="nb-toggle{" nb-toggle--on" if s=="1" else ""}">'
    f'<span class="nb-toggle__icon">{TOG[i]}</span><span class="nb-toggle__rail"></span></div>'
    for i, s in enumerate(a.toggles.split(",")))

acts = a.actions.split(",")
ICON = {"Shot":"&#9968;","Colour":"&#9682;","Focus":"&#10022;","Rename":"&#9998;",
        "Keys":"&#9000;","Display":"&#9645;","Lock":"&#9919;","Sleep":"&#9790;"}
def grid(items):
    cells = "".join(f'<div class="nb-action"><span class="nb-action__icon">'
                    f'{ICON.get(x,"&#9679;")}</span>{html.escape(x)}</div>' for x in items)
    return f'<div class="nb-actions__grid">{cells}</div>'
half = (len(acts) + 1) // 2
actions = grid(acts[:half]) + grid(acts[half:])

doc = f'''<!doctype html><meta charset=utf-8>
<style>
{CSS}
body {{ margin:0; padding:0; background:#070c16; }}
.nb-panel {{ width:{a.width - a.pad*2}px; padding:{a.pad}px; }}
</style>
<div class="nb-panel">
  <div class="nb-panel__head">
    <div class="nb-panel__time">{a.clock}</div>
    <div class="nb-panel__date" style="flex:1;padding:0 0 5px 12px">{a.date}</div>
    <div class="nb-settings">&#9881;</div>
  </div>
  <div style="display:flex;justify-content:space-around">{"".join(gauges)}</div>
  <div class="nb-toggles">{toggles}</div>
  <div style="display:flex;gap:10px">
    <div class="nb-actions">{actions}</div>
    <div class="nb-faders">
      <div class="nb-fader"><span class="nb-fader__icon">&#9834;</span>
        <div class="nb-fader__fill" style="--nb-pct:{a.vol}%"><span class="nb-fader__grip"></span><span class="nb-fader__val">{a.vol}</span></div></div>
      <div class="nb-fader"><span class="nb-fader__icon">&#9788;</span>
        <div class="nb-fader__fill" style="--nb-pct:{a.bri}%"><span class="nb-fader__grip"></span><span class="nb-fader__val">{a.bri}</span></div></div>
    </div>
  </div>
  <div class="nb-notes">
    <div class="nb-notes__head"><span>Notifications</span>
      <span class="nb-notes__clear">&#10005; Clear all</span></div>
    <div class="nb-notes__list">
      <div class="nb-note nb-note--warn"><span class="nb-note__dot"></span>
        <div style="flex:1"><div class="nb-note__title">Disk almost full</div>
        <div class="nb-note__body">87% used on system volume</div></div>
        <span class="nb-note__time">Now</span></div>
      <div class="nb-note"><span class="nb-note__dot"></span>
        <div style="flex:1"><div class="nb-note__title">Nightly build passed</div>
        <div class="nb-note__body">chief-site, 4m 12s</div></div>
        <span class="nb-note__time">Now</span></div>
    </div>
  </div>
</div>
'''
pathlib.Path(a.out).write_text(doc)
print(f"{a.out}: panel {a.width}px, {len(acts)} actions, gauges {a.gauges}")

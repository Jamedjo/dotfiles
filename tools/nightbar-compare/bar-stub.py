#!/usr/bin/env python3
"""His waybar config, with every custom module stubbed, for the headless mock.

The four custom modules shell out to his live state -- swaync's subscription,
the focuslock file, the Todoist API, the workspace he is on. In the mock each
one prints a drafted line and then waits, so the bar is photographed carrying
plausible content and nothing reaches out of the box."""
import json, pathlib, sys

SRC = pathlib.Path.home() / ".config/waybar/config"
OUT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "config.mock")

def strip_comments(text):
    out, i, n = [], 0, len(text)
    instr = False
    while i < n:
        c = text[i]
        if instr:
            out.append(c)
            if c == "\\":
                out.append(text[i+1]); i += 2; continue
            if c == '"':
                instr = False
            i += 1; continue
        if c == '"':
            instr = True; out.append(c); i += 1; continue
        if c == "/" and i + 1 < n and text[i+1] == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        out.append(c); i += 1
    return "".join(out)

cfg = json.loads(strip_comments(SRC.read_text()))
top, foot = cfg[0], cfg[1]

def stub(obj, payload):
    obj["exec"] = "printf '%s\\n' " + json.dumps(json.dumps(payload)) + "; sleep 100000"
    obj.pop("exec-if", None)
    obj.pop("restart-interval", None)

stub(top["custom/switchboard"], {"text": "Chief > V2 Review", "tooltip": "workspace"})
stub(top["custom/notification"],
     {"text": "3", "alt": "notification", "class": "notification", "tooltip": "3 notifications"})
stub(foot["custom/focuslock"], {"text": "Ship the bar refinements", "tooltip": ""})
stub(foot["custom/todoist"], {"text": "4 tasks · #MindfulChef", "tooltip": ""})

OUT.write_text(json.dumps(cfg, indent=2, ensure_ascii=False))
print("wrote", OUT)

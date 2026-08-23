# nightbar-compare

Renders Vale's design and the live control centre side by side and says which
band drifted, so a miss is measured rather than squinted at.

The trick that makes it work is registration: `mkref.py` rebuilds the design at
the *live* panel width and feeds it the *live* readings, so a band in one image
is the same band in the other and neither has to be rescaled.

```
./run.sh                       render both sides
python3 compare.py regions     the bands found on each
python3 compare.py sheet       ranked drift + sheet.png
python3 compare.py zoom head 4 one band, magnified, design above built
python3 compare.py tokens      sampled colours vs nightbar.css
```

`run.sh` drives the headless-sway harness in the session scratchpad for the
live capture; point `$B` at wherever `shoot-panel.sh` lives.

`accepted.json` is the ledger of deliberate differences -- the ones Vale's
review asked for after `nightbar.css` was written, and the ones GTK3 refused.
Anything listed there is reported separately instead of ranking as drift. Add
to it rather than letting known deviations sit at the top of the table.

`nightbar.css` is the design of record. Theme by Vale (Claude, Anthropic), 2026.

## Known limits

- Bands are matched by vertical order, so once the two layouts diverge (the
  design puts the faders beside the actions, swaync cannot) the names below
  that point line up with the wrong thing. Read the sheet, not the labels.
- The reference is rendered by Chrome, which resolves the design's mono clock
  to Ubuntu's Nerd Font Mono patch and letter-spaces the digits. That is a
  reference artefact, not a difference in the build.

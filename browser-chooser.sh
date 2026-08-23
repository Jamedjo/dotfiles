#!/bin/bash
# Fuzzy default browser. Registered with update-alternatives as the system
# browser, so a clicked link asks which browser opens it rather than waking
# whichever one has three hundred tabs.
#
# Wiring it up (none of this is intuitive):
#   sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser ~/browser-chooser.sh 200
#   sudo update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser ~/browser-chooser.sh 200
#   xdg-settings get default-web-browser   # check what xdg-open will use
#   ~/.config/mimeapps.list                # per-type overrides live here
#
# fuzzel replaced the old urxvt+fzf pipeline: it is a native layer-shell menu,
# so no terminal is spawned. Name and command are tab-separated because Exec=
# lines contain colons ("env FOO=bar cmd") that the old cut -d: mangled.

URL="$@"

browser_list=$(grep -l "Categories=.*WebBrowser" /usr/share/applications/*.desktop /var/lib/snapd/desktop/applications/*.desktop 2>/dev/null | \
    while read -r desktop; do
        name=$(grep "^Name=" "$desktop" | head -1 | cut -d= -f2-)
        exec_cmd=$(grep "^Exec=" "$desktop" | head -1 | cut -d= -f2- | sed 's/%[uU]//')
        printf '%s\t%s\n' "$name" "$exec_cmd"
    done | sort -u | awk -F'\t' '!seen[$1]++')

selected=$(printf '%s\n' "$browser_list" | cut -f1 \
    | fuzzel --dmenu --prompt='browser: ' --config="$HOME/.config/fuzzel/sway-menu.ini")
[ -n "$selected" ] || exit 0

cmd=$(printf '%s\n' "$browser_list" | awk -F'\t' -v s="$selected" '$1 == s { print $2; exit }')
[ -n "$cmd" ] || exit 1
exec $cmd $URL

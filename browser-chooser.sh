#!/bin/bash

# Get URL argument if provided
URL="$@"

# Find all browser .desktop files and extract their names and exec commands
# Use cut -d= -f2- to get everything after the first = sign
browser_list=$(grep -l "Categories=.*WebBrowser" /usr/share/applications/*.desktop /var/lib/snapd/desktop/applications/*.desktop 2>/dev/null | \
    while read desktop; do
        name=$(grep "^Name=" "$desktop" | head -1 | cut -d= -f2-)
        exec=$(grep "^Exec=" "$desktop" | head -1 | cut -d= -f2- | sed 's/%[uU]//')
        echo "$name:$exec"
    done | sort -u)

# Launch terminal with fzf to select browser
urxvt --title 'browser-chooser' -e bash -c "
    selected=\$(echo '$browser_list' | awk -F: '{print \$1}' | fzf --reverse --prompt='Select browser: ')
    if [ -n \"\$selected\" ]; then
        browser_cmd=\$(echo '$browser_list' | grep \"^\$selected:\" | cut -d: -f2-)
        \$browser_cmd $URL &
        sleep 2
    fi
"

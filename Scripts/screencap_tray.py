#!/usr/bin/python3

###
#
# Written by James Edwards-Jones
# Excuse the sloppy code as this was just to get something working
#
# MIT License
#
# Depends on `gir1.2-appindicator3` package
#
##

import os
import subprocess
import signal
from datetime import datetime
from gi.repository import Gtk as gtk, AppIndicator3 as appindicator

def main():
  #TODO: take geometry and filepath as input for more flexibility
  geometry = os.popen('slurp').read()
  filename = datetime.now().strftime("screencap_%F-%T.mp4")
  folder = os.path.expanduser('~/Screenshots')
  filepath = os.path.join(folder, filename)

  if geometry:
    print("using geometry " + geometry)
    print("recording to " + filepath)
    global process
    process = subprocess.Popen(['wf-recorder', '-g', geometry, '-f', filepath])
    indicator = appindicator.Indicator.new("sway-record", "media-record-symbolic", appindicator.IndicatorCategory.APPLICATION_STATUS)
    indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
    indicator.set_menu(build_menu())
    gtk.main()
  else:
    print("aborting due to missing geometry")

def build_menu():
  menu = gtk.Menu()
  stop_menu_item = gtk.MenuItem('Stop Recording')
  stop_menu_item.connect('activate', stop_recording)
  menu.append(stop_menu_item)
  menu.show_all()
  return menu

def stop_recording(_):
  os.kill(process.pid, signal.SIGINT)
  process.wait()
  gtk.main_quit()

if __name__ == "__main__":
  main()

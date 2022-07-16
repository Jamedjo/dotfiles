# Increases the max number of file descriptors per process from 1024
# Avoid sway crash when too many windows open or plugging in monitor with firefox open
ulimit -n 10000

export XDG_SESSION_TYPE=wayland # So firefox knows to use portals
export XDG_CURRENT_DESKTOP=sway # So portals knows to use wlr
export QT_STYLE_OVERRIDE=adwaita
export XCURSOR_SIZE=48
export XCURSOR_THEME=whiteglass
export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/
unset DISPLAY
WLC_DRM_DEVICE=card0 WLR_DRM_NO_MODIFIERS=1 dbus-launch --exit-with-session sway -d 2>~/sway.log

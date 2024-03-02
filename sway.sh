# Increases the max number of file descriptors per process from 1024
# Avoid sway crash when too many windows open or plugging in monitor with firefox open
ulimit -n 10000

export XDG_SESSION_TYPE=wayland # So firefox knows to use portals
export XDG_CURRENT_DESKTOP=sway # So portals knows to use wlr
export QT_STYLE_OVERRIDE=adwaita
export XCURSOR_SIZE=48
export XCURSOR_THEME=whiteglass
export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/
export LIBSEAT_BACKEND=logind
unset DISPLAY
#WLC_DRM_DEVICE=card0 WLR_DRM_NO_MODIFIERS=1 dbus-launch --sh-syntax --exit-with-session sway 2>~/sway.log
#NOTE: This should be run without dbus-launch when running from a launcher such a ly
#      Otherwise dbus-launch will be double-ran and DBUS_SESSION_BUS_ADDRESS will be set to a temp file instead of user sessions
#      This will result in snap packages being unable to be ran as cgroups cannot be created for them
#WLC_DRM_DEVICE=card0 WLR_DRM_NO_MODIFIERS=1 sway 2>~/sway.log
WLC_DRM_DEVICE=card0 WLR_DRM_NO_MODIFIERS=1 sway --my-next-gpu-wont-be-nvidia 2>~/sway.log

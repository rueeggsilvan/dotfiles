#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# awesome is kept as default
DEFAULT_SESSION=awesome

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrandr --output DP-0 --mode 2560x1440 --rate 143.97 --primary
xrandr --output DP-2 --mode 2560x1440 --rate 143.97 --right-of DP-0
xrandr --output DP-4 --mode 2560x1440 --rate 143.97 --left-of DP-0
xsetroot -cursor_name left_ptr
xss-lock slock &
udiskie &
picom &
pcmanfm -d &
unclutter --timeout 10 &
# Default session
session=${2:-awesome}
case $session in
  awesome ) exec awesome;;
  # If the session is not known, try to execute it as command
  * ) exec $1;;
esac
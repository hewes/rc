#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
xsetroot -cursor_name left_ptr
setxkbmap jp
xmodmap ~/.Xmodmap
xset dpms 0 0 0

# set wallpaper with feh
eval `cat ~/.fehbg`
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
ibus-daemon -r -x &
scim -d

exec ck-launch-session xmonad
#exec xfce4-session
#exec xmonad
#exec gnome-session

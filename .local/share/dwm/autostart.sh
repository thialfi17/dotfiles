#!/usr/bin/sh

./.fehbg &
picom &
dunst &
slstatus &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
setxkbmap -layout gb &
xss-lock custom-lock &

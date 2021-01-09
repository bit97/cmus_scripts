#!/bin/sh

# start cmus by checking for already running process
# if there are no running instance of it, the polybar bar is shown and cmus starts
# otherwise, the media player status is toggled

if pgrep -x mpv ; then
  socket=$(find /tmp -maxdepth 1 -type s | head -n1)
  echo 'cycle pause' | socat - $socket
elif ! pgrep -x cmus ; then
	polybar cmusBar -r &
	alacritty --class cmus -e cmus
else
	cmus-remote --pause
fi

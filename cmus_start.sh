#!/bin/sh

# start cmus by checking for already running process
# if there are no running instance of it, the polybar bar is shown and cmus starts
# otherwise, the media player status is toggled

if pgrep -x mpsyt ; then
  echo 'cycle pause' | socat - /tmp/mpsyt-mpvzpur7is1.sock
elif ! pgrep -x cmus ; then
	polybar cmusBar -r &
	alacritty --class cmus -e cmus
else
	cmus-remote --pause
fi

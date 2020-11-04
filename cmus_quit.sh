#!/bin/bash

# quit cmus
# kill the last polybar bar
# TODO: check if it is really the cmus bar
# restore the wallpaper: path to your original wallpaper

feh --bg-fill "$(cat $HOME/.config/wal/last-bg)"

[ $(pgrep --count polybar) -gt 1 ] \
	&& polybar-msg -p $(pgrep --newest polybar) cmd quit

exit 0

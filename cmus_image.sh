#!/bin/bash

# update the wallpaper with the addition of the currently playing track's album art
# downloads it if not present

ORIGINAL_WALLPAPER="$(cat $HOME/.config/wal/last-bg)"

h=$(mediainfo "$ORIGINAL_WALLPAPER" | grep Height | sed 's|[^0-9]||g')
let "h=h/3"

if ! cmus-remote -C >/dev/null 2>&1 ; then
    echo >&2 "cmus is not running"
    exit 1
fi

info=$(cmus-remote --query)

rm -f $HOME/.config/cmus/art.jpg

state=$(echo "$info" | sed -n 's/^status //p')
if [ "$state" = "stopped" ]||[ "$state" = "paused" ] ; then
    feh --bg-fill "$ORIGINAL_WALLPAPER"
    echo >&2 "no song playing currently, aborting!"
    exit 1
fi

rm $HOME/.config/cmus/file.jpg

file=$(echo "$info" | sed -n 's/^file //p')
# extract album art
ffmpeg -i "$file" -filter:v scale=-1:$h -an $HOME/.config/cmus/file.jpg

ls $HOME/.config/cmus/file.jpg > /dev/null

# kill other cover downloading operations
if [ $? -ne 0 ]; then
	echo "missing"
	# this is the default album art, feel free to download one you like and to change its path
	cp $HOME/Immagini/music.jpg $HOME/.config/cmus/file.jpg
	[ $(cat $HOME/.config/cmus/scripts/cmus_offline.status) -eq 1 ] && download_art.sh "$file" &
fi

# generate the composite wallpaper
echo "original wallpaper: $ORIGINAL_WALLPAPER"
gm composite -gravity Center $HOME/.config/cmus/file.jpg "$ORIGINAL_WALLPAPER" $HOME/.config/cmus/result.jpg

feh --bg-fill $HOME/.config/cmus/result.jpg

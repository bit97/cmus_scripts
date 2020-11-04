#!/bin/bash

# fetch currently playing tracks' metadata and try to download its album art
# N.B.: it will likely download random image either if the track has missing metadata or it's a rare/underground song

album=$(mediainfo "$1" | sed -n 's/^Album.*://p' | head -n 1)
artist=$(mediainfo "$1" | sed -n 's/^Performer.*://p' | head -n 1)

# avoid to start a big number of processes while skipping a big number of tracks
sleep 5

# check if song is still playing

file=$(cmus-remote --query | sed -n 's/^file //p')

[ "$file" == "$1" ] || exit 0

notify-send "downloading ${1} album art"

query="${artist} ${album}"

if [[ $(echo "${query}" | tr -d " " | wc -m) -le 1 ]]; then
	album=$(basename "$1")
	artist=""
fi

cover="$HOME/.config/cmus/arts/${album}.jpg"
temp="${file%.*}.temp.${file##*.}"

sacad "$artist" "$album" 600 "$cover"

ffmpeg -i "$file" -i "$cover" -y -map 0 -map 1 \
	-codec copy -disposition:v:0 attached_pic -map_metadata 0 "$temp" \
	&& mv -f "$temp" "$file" \
	&& notify-send "Added album art for ${album}" \
	&& cmus_image.sh

exit 0

#!/bin/bash

[ $# -ne 2 ] && echo "Usage: $0 ARTIST_NAME SONG_NAME" && exit 1

artist=${1// /%20}
track=${2// /%20}

#notify-send "Artist: $artist, Track: $track"

[ -z $track ] || [ -z $artist ] && notify-send "Missing album or artist info.. not suggesting album name" && exit 0

curl -H "Accept: application/json" -H "Content-Type: application/json" \
	http://musicbrainz.org/ws/2/recording/?query=$track%20AND%20artist:$artist | jq '.recordings' | grep -B 1 Album | grep title | cut -d \" -f 4 | sort | uniq -c | sort -k1,1nr -k2 | sed 's/^ *[0-9]* //' | dmenu -l 10 | tr -d '\n' | xclip -selection clipboard

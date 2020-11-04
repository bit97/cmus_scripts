#!/bin/bash

# allows to update currently playing track's metadata
# it launch album art retrieval after the update

function parse {
	input=$1
	title=$(echo "$input" | cut -d "|" -f 1)
	artist=$(echo "$input" | cut -d "|" -f 2)
	album=$(echo "$input" | cut -d "|" -f 3)
	track=$(echo "$input" | cut -d "|" -f 4)
  genre=$(echo "$input" | cut -d "|" -f 5)
  year=$(echo "$input" | cut -d "|" -f 6)
}

function print {
	echo "title=$title"
	echo "artist=$artist"
	echo "album=$album"
	echo "track=$track"
	echo "genre=$genre"
	echo "year=$year"
}

function is_running {
	status=$(cmus-remote --query 2>/dev/null | sed -n 's/^status //p')
	[[ $? -eq 0 && $status == "playing" ]]
}

function err {
	notify-send --urgency="critical" "$1"
	exit 1
}

###############

is_running || err "cmus is not playing any track"

apply_tag="tag.sh"
file=$(cmus-remote --query | sed -n 's/^file //p')

tags=$(
	yad --title "cmus tagger" --form \
		--field=title \
		--field=artist \
		--field=album \
		--field="track number" \
		--field=year:NUM \
		--field=genre
)

[ $? -ne 0 ] && err "form was closed"

parse "$tags"

print

$apply_tag \
	-c						\
	-a "$artist"	\
	-t "$title" 	\
	-A "$album"		\
	-n "$track"		\
	-y "$year"		\
	-g "$genre"		\
	"$file"

[ $? -ne 0 ] && err "error in applying tags"

cmus-remote -C "update-cache"

notify-send "${artist} - ${title}'s tags correctly added"

exit 0

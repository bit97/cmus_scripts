#!/bin/bash

# drag and drop the image in the box
# perform checks on the input URL
# download and set new album cover

# dependencies:
# dragon-drag-and-drop
# wget
# ffmpeg
# notify-send

function validate {
  url=$1
  egrep "\.(png|jpeg|gif|jpg)\s*$" <<< $url >/dev/null
}

url=$(dragon-drag-and-drop --target --and-exit)
validate $url || exit 1

prefix=$HOME/.config/cmus/arts
filename=$(basename $url)
wget --directory-prefix=$prefix $url

file=$(cmus-remote --query | sed -n 's/^file //p')
temp="${file%.*}.temp.${file##*.}"

ffmpeg -i "$file" -i "$prefix/$filename" -y -map 0 -map 1 \
  -codec copy -disposition:v:0 attached_pic -map_metadata 0 "$temp" \
  && mv -f "$temp" "$file" \
  && notify-send "Set album art" \
  && cmus_image.sh

exit 0

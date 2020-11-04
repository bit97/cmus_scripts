#!/bin/bash

# Define the output file path & name
opFile="$HOME/.config/cmus/cmus_output"

# cmus loop
while test $# -ge 2
do
  eval _$1='$2'
  shift
  shift
done

echo "$_title $_artist" > "$opFile"

sleep 0.2

# This sends a polybar hook to execute
# hook-0
polybar-msg hook cmus 1 >/dev/null 2>&1 &

# update image background
cmus_image.sh

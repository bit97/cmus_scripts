#!/bin/bash

status_file=$HOME/.config/cmus/scripts/cmus_offline.status

status=$(( ! $(cat $status_file) ))

[ $status -eq 0 ] && msg="Auto cover downloading OFF" || msg="Auto cover downloading ON"
notify-send "$msg"

echo $status > $status_file

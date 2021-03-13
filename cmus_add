#!/bin/bash

# search for files in Music folder and let you select which
# song you want to add to the cmus queue

# dependencies:
# fzf
# mediainfo

MUSIC_DIR="/media/DATA/Music"
MUSIC_EXT=".*(mp3|mp4|ogg|opus|webm|m4a|flac|wav|wma|aac)$"

while read -r track; do
  cmus-remote -q "$track"
done <<< "$(
            find ${MUSIC_DIR} -type f -regextype posix-extended -iregex $MUSIC_EXT |\
            fzf \
              --multi \
              --exact \
              --marker=* \
              --color=16 \
              --bind ctrl-a:toggle-all \
              --preview='
                mediainfo {} |\
                 egrep -i "^(artist|title|track name|album|performer|format)\s+:" |\
                 sort |\
                 uniq |\
                 sed "s/\( \)\{25\}:/:/"'\
              --preview-window='bottom:30%:wrap:follow:sharp'
          )"

exit 0

# cmus scripts
[cmus](https://cmus.github.io/) scripts that I personally use

## Dependencies

- polybar
- feh
- notify-send
- sacad
- mediainfo
- ffmpeg
- yad


## Other configs

Note: the scripts folder should be included in your PATH env variable.

### cmus
binds **q** key to *cmus_quit.sh* script
```
bind -f common q shell cmus_quit.sh && cmus-remote -C quit
```
allows the *cmus_image.sh* script and the polybar update to run on playback activities (play/pause/change track)
```
set status_display_program=update_polybar.sh
```

### Polybar
```
[module/cmus]
type = custom/ipc
hook-0 = cat $HOME/.config/cmus/cmus_output
initial = 1
format-prefix = "CMUS: "
format-prefix-foreground = ${colors.blue}
click-left = cmus-remote --prev
click-middle = cmus-remote --pause
click-right = cmus-remote --next
```

and [Enable IPC](https://github.com/polybar/polybar/wiki/Module:-ipc)

## Contribute

This project contains surely a number of bugs/unefficient code. Pardon me, is a lazy weekend's set of scripts.

Please open an issue if you find some bugs or need more clarifications

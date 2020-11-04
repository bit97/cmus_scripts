# cmus scripts
[cmus](https://cmus.github.io/) scripts that I personally use

## Dependencies

- polybar
- feh


## Other configs

Note: the scripts folder **should** be included in your PATH env variable.

### cmus
bind **q** key to *cmus_quit.sh* script
```
bind -f common q shell cmus_quit.sh && cmus-remote -C quit
```

### Polybar

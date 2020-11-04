#!/bin/bash

# toggle polybar bar's visibility
# TODO: check if it is really the cmus bar

[ $(pgrep --count polybar) -gt 1 ] \
	&& polybar-msg -p $(pgrep --newest polybar) cmd toggle

#!/usr/bin/env bash

# CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

this_pane=$(tmux display-message -p -F "#{window_height} #{pane_id} #{pane_left} #{pane_top} #{pane_height}")

read -r window_height pane_id left top height <<< "$this_pane"

too_tall=$(
	tmux list-panes -F '#{pane_id} #{pane_top} #{pane_height} #{pane_left}' \
         | awk "! /^$pane_id / && / $left$/ && \$3 > 1"
)

if [ -z "$too_tall" ]; then
	tmux select-pane -D 
	tmux resize-pane -y 98% # \; run-shell '~/1-sturob/tmux/root-mode.sh'
else
	tmux resize-pane -y 98%
fi

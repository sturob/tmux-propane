#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

new_height=$1

if [[ $1 =~ ^\+ || $1 =~ ^\- ]]; then
	height=$(tmux display-message -p -F '#{pane_height}')
	new_height=$((height $1))
fi

tmux resize-pane -y $new_height

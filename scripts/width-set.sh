#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

new_width=$1

if [[ $1 =~ ^\+ || $1 =~ ^\- ]]; then
	width=$(tmux display-message -p -F '#{pane_width}')
	new_width=$((width $1))
fi

tmux resize-pane -x $new_width

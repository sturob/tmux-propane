#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

new_width=$1

if [[ $1 =~ ^[0-9]+$ ]]; then  # check if it's a positive integer
	width=$(tmux display-message -p -F '#{pane_width}')
	new_width=$((width + $1))
elif [[ $1 =~ ^\- ]]; then  # check if it starts with a "-"
	width=$(tmux display-message -p -F '#{pane_width}')
	new_width=$((width $1))  # decrease the width
elif [[ $1 =~ ^\= ]]; then  # check if it starts with an "="
	new_width=${1:1}  # remove the "=" sign
fi

tmux resize-pane -x $new_width

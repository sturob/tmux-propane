#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

new_height=$1

if [[ $1 =~ ^[0-9]+$ ]]; then  # check if it's a positive integer
	height=$(tmux display-message -p -F '#{pane_height}')
	new_height=$((height + $1))
elif [[ $1 =~ ^\- ]]; then  # check if it starts with a "-"
	height=$(tmux display-message -p -F '#{pane_height}')
	new_height=$((height $1))  # decrease the height
elif [[ $1 =~ ^\= ]]; then  # check if it starts with an "="
	new_height=${1:1}  # remove the "=" sign
fi

tmux resize-pane -y $new_height

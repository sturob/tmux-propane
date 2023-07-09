#!/usr/bin/env bash

LOG=/tmp/propane.log

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_top_neighbours() {
    local this_id=$1

    # Get geometry and window of the current pane
    local this_geometry=$(tmux list-panes -F '#{pane_id} #{pane_top} #{pane_left} #{pane_right} #{window_id}' | grep "^$this_id")
    local this_top=$(echo "$this_geometry" | awk '{print $2}')
    local this_left=$(echo "$this_geometry" | awk '{print $3}')
    local this_right=$(echo "$this_geometry" | awk '{print $4}')
    local this_window=$(echo "$this_geometry" | awk '{print $5}')

    # Get all panes and their geometries in the same window
    local all_panes=$(tmux list-panes -F '#{pane_id} #{pane_bottom} #{pane_left} #{pane_right} #{window_id}' | grep "$this_window")

    # Find panes where pane_bottom is one less than this_top and x positions overlap
    top_neighbours=$(echo "$all_panes" | awk -v this_top="$this_top" -v this_left="$this_left" -v this_right="$this_right" \
		'$2 == this_top - 2 && $3 < this_right && $4 > this_left {print $1 $6}')

	local tallest_pane=$(echo "$top_neighbours" | sort -nrk2 | head -n1)
	echo $tallest_pane
}

read -r this_id this_height this_top< <(tmux display-message -p '#{pane_id} #{pane_height} #{pane_top}')

new_height=$(tmux capture-pane -p | uniq | wc -l)
height_delta=$((this_height - new_height))

if [[ $this_top = 0 || $1 = '-d' ]]; then
	tmux resize-pane -y $new_height
else
	big_above_id=$(get_top_neighbours $this_id)
	echo $big_above_id >> $LOG
	height=$(tmux display-message -t $big_above_id -p '#{pane_height}')
	new_height=$((height + height_delta))	
	tmux resize-pane -t $big_above_id -y $new_height
fi


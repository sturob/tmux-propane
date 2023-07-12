#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/propane.log"
DIRECTION=$1

# no stomping
if command -v flock >/dev/null 2>&1; then
	LOCKFILE=/tmp/propane-lockfile
	exec 200>$LOCKFILE
	flock -n 200 || { flock 200; } # Wait for lock on fd 200 (associated with $LOCKFILE) for the rest of the script
	# lock is automatically released when the script finishes or file descriptor is closed
fi

declare -A tmux_dir
tmux_dir[left]="L"
tmux_dir[right]="R"

read -r id height width is_left is_right is_top is_bottom< <(tmux display-message -p \
	'#{pane_id} #{pane_height} #{pane_width} #{pane_at_left} #{pane_at_right} #{pane_at_top} #{pane_at_bottom}')

[[ "$is_top" -eq 1 && "$is_bottom" -eq 1 ]] && is_full_height=true

if [ ! $is_full_height ]; then # isolate an edge case
	if [[ $is_left -eq 1 && $DIRECTION = 'left' || $is_right -eq 1 && $DIRECTION = 'right' ]]; then
		$CURRENT_DIR/full-edge.sh $id $DIRECTION
		exit
	fi
fi

[[ $DIRECTION = 'left' && "$is_left" -eq "1" ]] && goto_prev_window=true
[[ $DIRECTION = 'right' && "$is_right" -eq "1" ]] && goto_next_window=true

this_window_index=$(tmux display-message -p '#{window_index}')

if [ $goto_prev_window ]; then
	first_window_index=$(tmux list-windows | awk -F: '{print $1}' | sort -n | head -n1)
	if [ $this_window_index -eq $first_window_index ]; then # moving left from leftest window
	 	panes_n=$(tmux display-message -p '#{window_panes}')
		if [ $panes_n = 1 ]; then # there's no other panes so it would be a noop, move it to an existing window 
			tmux previous-window
			right_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_right}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
			tmux move-pane -b -s "$id" -t "$right_edge_pane"
			$CURRENT_DIR/full-edge.sh $id right
		else 
			tmux break-pane
		fi
	else # pane to previous window, full right edge
		tmux previous-window
		right_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_right}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
		tmux move-pane -b -s "$id" -t "$right_edge_pane"
		$CURRENT_DIR/full-edge.sh $id right
	fi
elif [ $goto_next_window ]; then
	last_window_index=$(tmux list-windows | awk -F: '{print $1}' | sort -n | tail -n1)
	if [ $this_window_index -eq $last_window_index ]; then # break off a pane into its own window if going right from last window
		panes_n=$(tmux display-message -p '#{window_panes}')
		if [ $panes_n = 1 ]; then # if there's no other panes then it's pointless
			tmux next-window
			left_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_left}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
			tmux move-pane -b -s "$id" -t "$left_edge_pane"
			$CURRENT_DIR/full-edge.sh $id left
		else
			tmux break-pane
		fi
	else
		tmux next-window
		left_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_left}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
		tmux move-pane -b -s "$id" -t "$left_edge_pane"
		$CURRENT_DIR/full-edge.sh $id left
	fi
else # a normal move
	tmux select-pane -${tmux_dir[$DIRECTION]} # left-of/right-of too buggy, should be doing this ourselves tho

	target=$(tmux display-message -p '#{pane_id} #{pane_height}')
	target_id=$(echo $target | awk '{print $1}')
	target_height=$(echo $target | awk '{print $2}')

	if [ $target_height -eq $height ]; then # swap if same height
		tmux swap-pane -s $id -t $target_id
	else
		tmux move-pane -b -s $id -t $target_id
	fi

	tmux select-pane -t $id 
fi

# $! try -b if error 

# resize if taller than original

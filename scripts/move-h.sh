#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/propane.log"

dir=$1

declare -A tmux_dir
tmux_dir[left]="L"
tmux_dir[right]="R"

read -r id height width is_left is_right is_top is_bottom< <(tmux display-message -p '#{pane_id} #{pane_height} #{pane_width} #{pane_at_left} #{pane_at_right} #{pane_at_top} #{pane_at_bottom}')

[[ $dir = 'left' && "$is_left" -eq "1" ]] && prev_window=true
[[ $dir = 'right' && "$is_right" -eq "1" ]] && next_window=true
[[ "$is_top" -eq 1 && "$is_bottom" -eq 1 ]] && full_height=true

if [ $prev_window ]; then

	if [ ! $full_height ]; then
		$CURRENT_DIR/full-edge.sh $id left
		exit
	fi

	this_window=$(tmux display-message -p '#{window_index}')
	first_window=$(tmux list-windows | awk -F: '{print $1}' | sort -n | head -n1)

	# break off a pane into its own window if going left from first window
	if [ $this_window -eq $first_window ]; then
		n=$(tmux display-message -p '#{window_panes}')
		if [ $n = 1 ]; then # if there's no other panes then it's pointless
			tmux previous-window
			right_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_right}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
			tmux move-pane -b -s "$id" -t $right_edge_pane
		else
			tmux break-pane
		fi
	else
		tmux previous-window
		# tmux join-pane -s "$id"
		right_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_right}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
		tmux move-pane -b -s "$id" -t "$right_edge_pane"
	fi

	# todo
	# 	get panes with pane_at_right
	# 	if is_top 
	#		get top pane in this window
	#		try to join-pane before top, if error after
	#   else if is_bottom
	#		get bottom pane
	# 		try to join after, if error before
	#   if error find tallest pane and join before/after

elif [ $next_window ]; then

	if [ ! $full_height ]; then
		$CURRENT_DIR/full-edge.sh $id right
		exit
	fi

	this_window=$(tmux display-message -p '#{window_index}')
	last_window=$(tmux list-windows | awk -F: '{print $1}' | sort -n | tail -n1)

	# break off a pane into its own window if going right from last window
	if [ $this_window -eq $last_window ]; then
		n=$(tmux display-message -p '#{window_panes}')
		if [ $n = 1 ]; then # if there's no other panes then it's pointless
			tmux next-window
			left_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_left}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
			tmux move-pane -b -s "$id" -t "$left_edge_pane"
			# tmux join-pane -s "$id"
		else
			tmux break-pane
		fi
	else
		tmux next-window
		left_edge_pane=$( tmux list-panes -F '#{pane_id} #{pane_at_left}' | awk "/ 1$/" | head -n 1 | awk '{print $1}')
		tmux move-pane -b -s "$id" -t "$left_edge_pane"
		# tmux join-pane -s "$id"
	fi
else 
	tmux select-pane -${tmux_dir[$dir]} # left-of/right-of too buggy

	target=$(tmux display-message -p '#{pane_id} #{pane_height}')
	target_id=$(echo $target | awk '{print $1}')
	target_height=$(echo $target | awk '{print $2}')

	if [ $target_height -eq $height ]; then
		tmux swap-pane -s $id -t $target_id
		# if target_id != id
		# if [ $is_top = '1' ]; then # TODO find top pane
		# 	# tmux swap-pane -s $id -t $target_id
		# fi
	else
		tmux move-pane -b -s $id -t $target_id
	fi

	tmux select-pane -t $id 
fi

# $! try -b if error 

# resize if taller than original

#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/propane.log"

dir=$1

lockfile=/tmp/mylockfile
exec 200>$lockfile
# Wait for lock on fd 200 (associated with $lockfile) for the rest of the script
flock -n 200 || { flock 200; }
# lock will be automatically released when the script finishes or the file descriptor is closed

declare -A tmux_dir
tmux_dir[up]="U"
tmux_dir[down]="D"

# Save the original pane's id and size
read -r original_pane original_pane_height original_pane_width is_top is_bottom is_left is_right< <(tmux display-message -p '#{pane_id} #{pane_height} #{pane_width} #{pane_at_top} #{pane_at_bottom} #{pane_at_left} #{pane_at_right}')

[[ $dir = 'up' && "$is_top" -eq "1" ]] && prev_session=true
[[ $dir = 'down' && "$is_bottom" -eq "1" ]] && next_session=true

[[ "$is_left" -eq 1 && "$is_right" -eq 1 ]] && full_width=true

id=$original_pane

if [ $prev_session ]; then
	if [ ! $full_width]; then
		$CURRENT_DIR/full-edge.sh $id up
		exit
	fi

	tmux switch-client -p
	bottom_edge_pane=$(
		tmux list-panes -F '#{pane_id} #{pane_at_bottom}' | awk "/ 1$/" | head -n 1 | awk '{print $1}'
	)
	tmux join-pane -s "$id" -t "$bottom_edge_pane" # shouldnt this be move-pane ?
	$CURRENT_DIR/full-edge.sh $id down
elif [ $next_session ]; then
	if [ ! $full_width]; then
		$CURRENT_DIR/full-edge.sh $id down
		exit
	fi
	tmux switch-client -n
	top_edge_pane=$(
		tmux list-panes -F '#{pane_id} #{pane_at_top}' | awk "/ 1$/" | head -n 1 | awk '{print $1}'
	)
	# tmux join-pane -s "$id" # -b -t "$top_edge_pane"
	tmux move-pane -s "$id" -b -t "$top_edge_pane"
	$CURRENT_DIR/full-edge.sh $id up 
	# echo "$top_edge_pane and $id" >> $LOG
else 
	# Move to the pane above/below and save its id and size
	tmux select-pane -${tmux_dir[$dir]}
	read -r above_pane above_pane_height above_pane_width < <(tmux display-message -p '#{pane_id} #{pane_height} #{pane_width}')

	if [ $original_pane_width = $above_pane_width ]; then
		tmux swap-pane -s $original_pane -t $above_pane
		tmux select-pane -t $original_pane
		tmux resize-pane -t $original_pane -y $original_pane_height

		# this is faster, but sizes get more fucked up
		# if [ $dir = 'U' ]; then
		# 	tmux move-pane -b -s $original_pane -t $above_pane # >> $LOG
		# else
		# 	tmux move-pane -s $original_pane -t $above_pane # >> $LOG
		# fi
	else
		if [$full_width]; then
			if [ $dir = 'up' ]; then
				tmux move-pane -h    -s $original_pane -t $above_pane # >> $LOG
			else
				tmux move-pane -h -b -s $original_pane -t $above_pane # >> $LOG
			fi
		else
			if [ $dir = 'up' ]; then
				tmux move-pane -v    -s $original_pane -t $above_pane # >> $LOG
			else
				tmux move-pane -v -b -s $original_pane -t $above_pane # >> $LOG
			fi
		fi
	fi
fi

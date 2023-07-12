#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/propane.log"
DIRECTION=$1

# no stomping
if command -v flock >/dev/null 2>&1; then
	LOCKFILE=/tmp/propane-lockfile
	exec 200>$LOCKFILE
	flock -n 200 || { flock 200; } # Wait for lock on fd 200 (associated with $LOCKFILE) for the rest of the script
	# lock will be automatically released when the script finishes or file descriptor is closed
fi

declare -A tmux_dir
tmux_dir[up]="U"
tmux_dir[down]="D"

# Save the original pane's id and size
read -r id pane_height pane_width is_top is_bottom is_left is_right< <(tmux display-message -p \
	    '#{pane_id} #{pane_height} #{pane_width} #{pane_at_top} #{pane_at_bottom} #{pane_at_left} #{pane_at_right}')

[[ $DIRECTION = 'up' && "$is_top" -eq "1" ]] && goto_prev_session=true
[[ $DIRECTION = 'down' && "$is_bottom" -eq "1" ]] && goto_next_session=true

[[ "$is_left" -eq 1 && "$is_right" -eq 1 ]] && is_full_width=true

if [[ ($goto_prev_session || $goto_next_session) && ! $is_full_width ]]; then
	$CURRENT_DIR/full-edge.sh $id $DIRECTION
	exit
fi

if [ $goto_prev_session ]; then
	tmux switch-client -p
	bottom_edge_pane=$(
		tmux list-panes -F '#{pane_id} #{pane_at_bottom}' | awk "/ 1$/" | head -n 1 | awk '{print $1}'
	)
	tmux join-pane -s "$id" -t "$bottom_edge_pane" # shouldnt this be move-pane ?
	$CURRENT_DIR/full-edge.sh $id down
elif [ $goto_next_session ]; then
	tmux switch-client -n
	top_edge_pane=$(
		tmux list-panes -F '#{pane_id} #{pane_at_top}' | awk "/ 1$/" | head -n 1 | awk '{print $1}'
	)
	# tmux join-pane -s "$id" # -b -t "$top_edge_pane"
	tmux move-pane -s "$id" -b -t "$top_edge_pane"
	$CURRENT_DIR/full-edge.sh $id up 
else # a normal move - switch to the pane above/below and save its id and size
	tmux select-pane -${tmux_dir[$DIRECTION]}
	read -r target_pane target_pane_height target_pane_width < <(tmux display-message -p '#{pane_id} #{pane_height} #{pane_width}')

	if [ $pane_width = $target_pane_width ]; then # swap if the same width
		tmux swap-pane -s $id -t $target_pane
		tmux select-pane -t $id
		tmux resize-pane -t $id -y $pane_height
		# faster, but sizes get more fucked up:
		# if [ $DIRECTION = 'U' ]; then tmux move-pane -b -s $id -t $target_pane # >> $LOG
		# else tmux move-pane -s $id -t $target_pane # >> $LOG
		# fi
	else 
		if [$is_full_width]; then
			if [ $DIRECTION = 'up' ]; then
				tmux move-pane -h    -s $id -t $target_pane # >> $LOG
			else
				tmux move-pane -h -b -s $id -t $target_pane # >> $LOG
			fi
		else
			if [ $DIRECTION = 'up' ]; then
				tmux move-pane -v    -s $id -t $target_pane # >> $LOG
			else
				tmux move-pane -v -b -s $id -t $target_pane # >> $LOG
			fi
		fi
	fi
fi

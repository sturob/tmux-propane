#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pane_id=$1
edge=$2

function latest_pane () {
	echo -n '%'
	tmux list-panes -F '#{pane_id}' | sed 's/^.//' | sort -g | tail -n1
}

function flip_n_kill () {
	tmp_pane=$(latest_pane)
	tmux swap-pane -s $tmp_pane -t $pane_id
	tmux kill-pane -t $tmp_pane
}

case $edge in
    "up")
		tmux split-window -f -b -l 10
		flip_n_kill
        ;;
    "down")
		tmux split-window -f  -l 10
		flip_n_kill
        ;;
    "left")
		tmux split-window -f -h -b -l 45
		flip_n_kill
        ;;
    "right")
		tmux split-window -f -h  -l 45
		flip_n_kill
        ;;
esac


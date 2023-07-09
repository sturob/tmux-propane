#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# https://stackoverflow.com/a/70024796
# tmux move-pane -h -t '.{up-of}'
# tmux move-pane -t '.{right-of}'
# tmux move-pane -t '.{left-of}'
# tmux move-pane -h -t '.{down-of}'
direction=$1

# $before='-b'

tmux move-pane -h -b -t ".{$direction-of}"


# this_pane=$(tmux display-message -p -F '#{pane_id} #{pane_left}')

# read -r pane_id left <<< "$this_pane"

# all_panes_in_this_column=$(tmux list-panes -F '#{pane_id} #{pane_height} #{pane_left}' \
# 	| awk "\$3 == $left" ) # && ! /^$pane_id /")

# heights=$(printf "%s\n" "$all_panes_in_this_column" | awk '{ print $2 }' | awk -f equal.awk)

# paste <(printf "%s\n" "$all_panes_in_this_column") <(printf "%s\n" "$heights") \
# 	| while IFS=$'\t' read -r pane height; do
#   id=$(echo "$pane" | awk '{print $1}')
#   # echo "Applying height $height to ID $id"
#   tmux resize-pane -t "$id" -y "$height" 
# done



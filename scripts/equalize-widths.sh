#!/usr/bin/env bash

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# the algo for tmux select-layout -E does not handle large numbers of windows well
# all windows are equal, except the last one, which can be taller by up to n-2
# here is a more equal height distribution, vertically at least

this_pane=$(tmux display-message -p -F '#{pane_id} #{pane_top}')

read -r pane_id top <<< "$this_pane"

all_panes_in_this_row=$(tmux list-panes -F '#{pane_id} #{pane_width} #{pane_top}' \
	| tac | awk "\$3 == $top" ) # && ! /^$pane_id /")

widths=$(printf "%s\n" "$all_panes_in_this_row" | awk '{ print $2 }' | awk -f equal.awk)

echo $widths 

paste <(printf "%s\n" "$all_panes_in_this_row") <(printf "%s\n" "$widths") \
	| while IFS=$'\t' read -r pane width; do
  id=$(echo "$pane" | awk '{print $1}')
  tmux resize-pane -t "$id" -x "$width" 
done



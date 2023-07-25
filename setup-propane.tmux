#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )""/scripts"

tmux bind -n  M-x  run-shell -b "$CURRENT_DIR/prompt-for-width.sh"
tmux bind -n  M-y  run-shell -b "$CURRENT_DIR/prompt-for-height.sh"

tmux bind -n  M-w  run-shell -b "$CURRENT_DIR/move-v.sh up"
tmux bind -n  M-a  run-shell -b "$CURRENT_DIR/move-h.sh left"
tmux bind -n  M-s  run-shell -b "$CURRENT_DIR/move-v.sh down"
tmux bind -n  M-d  run-shell -b "$CURRENT_DIR/move-h.sh right"

tmux bind -n  M-W  run-shell -b "$CURRENT_DIR/nudge.sh up"
tmux bind -n  M-A  run-shell -b "$CURRENT_DIR/nudge.sh left"
tmux bind -n  M-S  run-shell -b "$CURRENT_DIR/nudge.sh down"
tmux bind -n  M-D  run-shell -b "$CURRENT_DIR/nudge.sh right"

tmux bind -N " * y-maximize pane"  -n  M-m  run-shell -b "$CURRENT_DIR/maximize.sh" #resize-pane -y 98%
tmux bind -N " * y-minimize pane"  -n  M-n  run-shell -b "$CURRENT_DIR/trim.sh" #resize-pane -y 98%
tmux bind -N " * y-minimize pane"  -n  M-N  run-shell -b "$CURRENT_DIR/trim.sh -d" #resize-pane -y 98%
tmux bind -n  M-"=" select-layout -E #  select-pane -D \; resize-pane -y 98%  # \; run-shell "~/1-sturob/tmux/root-mode.sh"


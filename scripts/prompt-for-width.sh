#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux command-prompt -p"width:" "run-shell -b '$CURRENT_DIR/width-set.sh %1'"


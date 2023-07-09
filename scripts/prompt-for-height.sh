#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux command-prompt -p"height:" "run-shell -b '$CURRENT_DIR/height-set.sh %1'"


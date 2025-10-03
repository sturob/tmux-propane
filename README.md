# tmux-propane 

Effortlessly rearrange panes and modify window layouts in tmux.

There are also 4 functions to change pane size based on your current context: **Trim height**, **Maximize** (cycles vertically if already maximized), **Equalize**, and **Size to**.

<!-- ## Demos (asciinema/gifs) -->

<!-- Move a pane between columns -->

<!-- Move a pane between windows -->

<!-- Trim vim instinces -->

<!-- Toggle between column panes -->

## How it works
ALT + wasd key (<kbd>ALT + w</kbd> <kbd>ALT + a</kbd> <kbd>ALT + s</kbd> <kbd>ALT + d</kbd>) moves the current pane in any direction. When panes reach window edges, they snap to occupy the full edge length. This enables most arrangements you'll need.

Panes are moved between windows by moving them off the left or right edge of the screen, and between sessions by moving up or down. Moving a pane to the right of the last window in a session automatically creates a new window for that pane.

## Rules
* Panes swap vertically if they have equal width (<kbd>ALT + w</kbd> or <kbd>ALT + s</kbd>) \*
* Panes swap horizontally if they have equal height (<kbd>ALT + a</kbd> or <kbd>ALT + d</kbd>) \*
* Moving a pane to the edge of a window will make it occupy the entire edge (full height or width)
* Moving an edge pane again shifts it to the adjacent window (horizontal movement) or session (vertical movement)

\* If not equal, the pane will move to join the next column or row

## A few propane accessories:
tmux-propane offers additional ways to resize panes:

- **Trim**: Reduces pane height by counting and removing duplicate lines, perfect for eliminating empty space in text editors or command prompts (<kbd>ALT + n</kbd>)
- **Maximise**: Fills the entire space, leaving only a single line for each of the other panes (<kbd>ALT + m</kbd>)
- **Equalize**: Uses the select-layout -E command to distribute panes evenly (<kbd>ALT + =</kbd>)
- **Size to**: Alter pane height (<kbd>ALT + y</kbd>) or width (<kbd>ALT + x</kbd>) using absolute (=N) or relative (N or -N) integer values

## Who is this for?
tmux-propane is designed for tmux users who already have a basic configuration for navigating windows and spliting+resizing panes but want more pane control capabilities.

## Dependencies
- flock (optional but recommended for queueing motions and preventing rapid commands stomping on each other)
- awk
- on macOS you'll need to get your <kbd>ALT</kbd> key passed through into your terminal

## Installation

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'sturob/tmux-propane'

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/sturob/tmux-propane ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/propane.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`.
You should now be able to use the plugin.
## Issues

### tmux < 3.2
Using any of the five predefined layouts with select-layout or next-layout in tmux versions earlier than 3.2 may cause instability. Avoid using these commands if you want tmux-propane to function properly.

# tmux-propane 

Effortlessly rearrange panes and modify window layouts in tmux.

There are also 4 functions to change pane size based on your current context: **Trim height**, **Maximize** (cycles vertically if already maximized), **Equalize**, and **Size to**.

<!-- ## Demos (asciinema/gifs) -->

<!-- Move a pane between columns -->

<!-- Move a pane between windows -->

<!-- Trim vim instinces -->

<!-- Toggle between column panes -->

## How it works
ALT + wasd key (<kbd>ALT+w</kbd> <kbd>ALT+a</kbd> <kbd>ALT+s</kbd> <kbd>ALT+d</kbd>) moves the current pane in any direction. When panes reach window edges, they snap to occupy the full edge length, this enables most complex arrangements.

Panes are moved between windows by moving them off the left or right edge of the screen, and between sessions by moving up or down. Moving a pane to the right of the last window in a session automatically creates a new window for that pane.

## Rules
1. Panes swap vertically if they have equal width (<kbd>ALT+a</kbd> or <kbd>ALT+d</kbd>) \*
2. Panes swap horizontally if they have equal height (<kbd>ALT+w</kbd> or <kbd>ALT s</kbd>) \*
3. Moving a pane to the edge of a window will make it occupy the entire edge (full height or width)
4. Moving an edge pane again shifts it to the adjacent window (horizontal movement) or session (vertical movement)

\* If not equal, the pane will move to join the next column or row

## A few propane accessories:
tmux-propane offers novel ways to resize panes:

- **Trim**: Reduces pane height by counting and removing duplicate lines, perfect for eliminating empty space in text editors or command prompts (<kbd>ALT+n</kbd>)
- **Maximise**: Fills the entire space, leaving only a single line for each of the other panes (<kbd>ALT+m</kbd>)
- **Equalize**: Uses the select-layout -E command to distribute panes evenly (<kbd>ALT+=</kbd>)
- **Size to**: Alter pane height (<kbd>ALT+y</kbd>) or width (<kbd>ALT+x</kbd>) using absolute (=N) or relative (N or -N) integer values

## Who is this for?
tmux-propane is designed for tmux users who already have a basic configuration for navigating windows and spliting+resizing panes but want more pane control capabilities.

## Dependencies
- flock (optional but recommended for queueing motions and preventing rapid commands stomping on each other)
- awk
- on macOS you'll need to get your <kbd>ALT</kbd> key passed through into your terminal

## Issues

### tmux < 3.2
Using any of the five predefined layouts with select-layout or next-layout in tmux versions earlier than 3.2 may cause instability. Avoid using these commands if you want tmux-propane to function properly.

# tmux-propane 

Effortlessly rearrange+resize panes and modify window layouts in tmux

<!-- ## Demos (asciinema/gifs) -->

<!-- Move a pane between columns -->

<!-- Move a pane between windows -->

<!-- Trim vim instinces -->

<!-- Toggle between column panes -->

## How it works
Use the wasd keys and alt (alt-w alt-a alt-s alt-d) to move the current pane in any direction. When panes reach window edges, they snap to the full edge, enabling complex rearrangement.

Panes can be moved between windows by moving them off the left or right edge of the screen, and between sessions by moving up or down. Moving a pane to the right of the last window in a session automatically creates a new window for that pane.

## Rules
1. Panes swap vertically if they have equal width (alt-a or alt-d) *
2. Panes swap horizontally if they have equal height (alt-w or alt-s) *
3. Moving a pane to the edge of a window will make it occupy the entire edge (full height or width)
4. Moving an edge pane again shifts it to the adjacent window (horizontal movement) or session (vertical movement)

\* If not equal, the pane will move to join the next column or row

These rules, combined with resizing and spliting, should enable the creation of all possible layouts


## A few propane accessories:
tmux-propane offers novel ways to resize panes:

- **Trim**: Reduces pane height by counting and removing duplicate lines, perfect for eliminating empty space in text editors or command prompts (*alt-n*)
- **Maximise**: Fills the entire space, leaving only a single line for each of the other panes (*alt-m*)
- **Equalize**: Uses the select-layout -E command to distribute panes evenly (a more robust implementation is planned) (*alt-=*)
- **Size to**: Alter pane height (*alt-y*) or width (*alt-x*) using absolute (=N) or relative (N or -N) integer values

## Who is this for?
tmux-propane is designed for tmux users who already have a basic configuration for navigating windows and resizing panes but desire enhanced pane control capabilities.

## Dependencies
- flock (optional but recommended for queueing motions and preventing rapid commands stomping on each other)
- awk

## Issues

### tmux < 3.2
Using any of the five predefined layouts with select-layout or next-layout in tmux versions earlier than 3.2 may cause instability. Avoid using these commands if you want tmux-propane to function properly.

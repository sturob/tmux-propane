# tmux-propane 

Rearrange panes and alter window layouts with ease. Move the current pane anywhere.

## Objectives

- make any possible layout
- be reasonably intuitive, with rules simple enough to pick up quickly
- use as few keys as possible
- allow panes to be moved between windows and sessions 

## Demos (asciinema/gifs)

Move a pane between columns

Move a pane between windows

Trim vim instinces

Toggle between column panes


## How it works

Use alt + a wasd key to move the current pane in any direction. Panes go full-edge when they hit window edges, this is a bit weird at first, but allows for more complex rearrangements.

Panes can be moved between windows by moving off the left or right edge of the screen, and between sessions up or down.

If you move right of the last window in a session, a new window will be created specifically for the pane.


## Rules

- Vertical panes swap if they are the same width - they are in a column
- Horizontal panes swap if they are the same height - they are in a row
- Otherwise, the pane will be moved between columns or rows
- Moving a pane into a window edge will make it edged (occupy the whole edge).
- Moving an edged pane into a window's edge will move it to the adjacent window (horizontally movement) or adjacent session (vertical movement).

This isn't watertight but enables all possible layouts, even if some need a little indirection to achieve.


## A few propane accessories:

These are novel ways to resize panes:

trim
	count the number of duplicate lines in a pane and reduce height accordingly. good for trimming empty space in text editors or command prompts.
	alt-n

maximise
	fill the whole space leaving only a single line for each of the other panes
	alt-m

equalize
	using the buggy select-layout -E currently (a more sound implimentation is on the way)
	alt-=

stated resizes
	enter absolute (=N) or relative (N or -N) integer to the alter height (y) or width (x) 
	alt-x
	alt-y


## Who is this for?

This plugin is for tmux users who already have a basic config for navigating windows + resizing panes, but want improved ways to control panes.


## Dependencies

flock - not necessary but useful to queue motions and prevent multiple commands stomping on each other

awk

tmux > 3.2 ideally - many strange layout bugs are present with earlier tmuxes


## Issues

tmux < 3.2 will go crazy if you set any of the 5 predefined layouts using select-layout or next-layout. So don't do that if you want this plugin to work.

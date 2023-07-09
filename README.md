# tmux-propane 

The essence of this plugin is making it easy to rearrange panes and alter layouts by moving the current pane.

## Objectives

- make any layout possible
- be reasonably intuitive / with rules simple enough to pick up quickly
- use as few keys as possible
- allow panes to be moved between windows and sessions 

## How it works

Use the wasd keys (holding alt) to move the current pane in any direction. Panes go full-edge when they hit window edges, this seems a bit weird, but allows for more complex rearrangements.

## a few propane accessories:

These are novel ways to resize panes:

trim
	count the number of duplicate lines in a pane and reduce accordingly. good for trimming empty space in text editors or command prompts.
	alt-n

maximise
	fill the whole space leaving only a single line for each of the other panes
	alt-m

equalize
	still using select-layout -E atm, but a more sound implimentation is on the way
	alt-=

stated resizes
	enter absolute (N) or relative (+N or -N) integer to the alter height (y) or width (x) 
	alt-x
	alt-y

## Who is this for?

This plugin is for tmux users who have already got a basic config that works for them, but want improved ways to manage panes.

## Issues

tmux < 3.2 will go crazy if you set any of the 5 predefined layouts using select-layout or next-layout. So don't do that if you want this plugin to work.

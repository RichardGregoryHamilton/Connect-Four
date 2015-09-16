Connect-Four
============

This is a command line game written in Ruby. As a clone of the popular board game, Connect Four, the objective is to match four consecutive tiles to win

How To Play
===========

* Open a command line and clone this repository. ` git clone git@github.com:RichardGregoryHamilton/Connect-Four.git`
* Make sure you have `Rails` and `Bundler` installed because Connect-Four requires the `colorize` gem
* Install this gem with `gem install colorize`
* Run `ruby connect_four.rb` and have some fun

Gameplay
=======

The computer randomly decides who goes first and which color your given. Your objective is to match four consecutive tiles of your color either horizontally, vertically or diagonally.

Select a column to put your tile in. Then it will be your opponent's turn.

If all cells in the board are filled with tiles and there is no horizontal, vertical or diagonal combination of four consecutive
tiles of the same color, the game will end in a draw.

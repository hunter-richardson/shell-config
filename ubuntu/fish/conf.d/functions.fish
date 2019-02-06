#!/bin/fish

set --local MY_DIR (realpath (command dirname (builtin status filename)))
source $MY_DIR/functions/*.fish
source $MY_DIR/functions/fundle/*.fish

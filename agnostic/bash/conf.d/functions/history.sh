#!/bin/bash

function history {
  [ ! -s $HOME/.bash_history ] && builtin printf '%sNo %s history!%s\n' $(format bold) $SHELL $(format normal) && builtin return 0
  [ $# -eq 0 ] && command less $HOME/.bash_history && builtin printf '%s history may be filtered by:\t history [string query]\n' $(command basename $SHELL) && builtin return 0
  command grep "$*" $HOME/.bash_history --color=always | command grep -v "$HOME/.bash_history"
}

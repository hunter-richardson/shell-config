#!/bin/bash

function exit()
{
  if [ -z "$TMUX" ]
  then
    builtin exit
  else if [ -n "$1" && $1 == 'all' ]
    if [ $(command tmux list-sessions | wc -l) -eq 0 ]
    then
      builtin exit
    else
      command tmux clear-history 2>/dev/null
      command tmux kill-server 2>/dev/null
    fi
  else
    case $(command tmux list-sessions | wc -l)
      0)
        builtin exit
        ;;
      1)
        command tmux clear-history 2>/dev/null
        command tmux kill-server 2>/dev/null
        ;;
      *)
        command tmux kill-window 2>/dev/null
        ;;
    esac
  fi
  builtin exit
}


#!/bin/fish

function exit -d 'destroy tmux server on exit'
  if builtin set -q TMUX
    builtin exit
  else if builtin test "$argv[1]" = "all"
    if builtin test (command tmux list-sessions | wc -l) -eq 0
      builtin exit
    else
      command tmux clear-history 2>/dev/null
      command tmux kill-server 2>/dev/null
    end
  else
    switch (command tmux list-sessions | wc -l)
      case 0
        builtin exit
      case 1
        command tmux clear-history 2>/dev/null
        command tmux kill-server 2>/dev/null
      case '*'
        command tmux kill-window 2>/dev/null
    end
  end
  builtin exit
end

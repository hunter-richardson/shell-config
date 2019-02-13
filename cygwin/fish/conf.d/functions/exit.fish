#!/bin/fish

function exit
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
  exit
end

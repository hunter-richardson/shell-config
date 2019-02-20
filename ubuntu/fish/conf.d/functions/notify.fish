#!/usr/bin/fish

function notify -d 'speak done when the given or most recent command completes'
  builtin set -q $argv;
    and eval $argv &
  builtin set -l $proc (builtin jobs -l -p)
  builtin test -n $proc;
    and command tail -f --pid=$proc;
      and builtin command -v spd-say;
      and speak 'done';
      or  builtin echo \a
end

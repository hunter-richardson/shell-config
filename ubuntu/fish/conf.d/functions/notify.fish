#!/usr/bin/fish

function notify -d 'beep when the given or most recent command completes'
  builtin set -q $argv;
    and eval $argv &
  builtin set -l $proc (builtin jobs -l -p)
  builtin test -z $proc;
    and builtin return 0;
    or  command tail -f --pid=$proc;
      and speak 'done';
      and return 0
end

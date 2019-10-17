#!/usr/bin/fish

function repeat -d 'Retry a command infinitely, until it exits successfully or a signal is caught'
  builtin set -l num 0
  while builtin test $num -ge 0
    eval $argv
    builtin set -l cmd_status $status
    builtin set -l num (math "1 + $num")
    if builtin test $cmd_status -eq 0
      builtin printf 'Try %s%s#%d%s succeeded.\n' $bold $green $num $normal
      builtin return 0
    else
      builtin set -l wait (math "2 ^ ($num - 1)")
      builtin printf 'Try %s%s#%d%s exited %s%s%s%s, retrying in %s%s%s%s...\n' $bold $green $num $normal $bold $red $cmd_status $normal $bold $yellow (math "1000 * $wait" | humanize_duration) $normal
      command sleep $wait
    end
  end
end

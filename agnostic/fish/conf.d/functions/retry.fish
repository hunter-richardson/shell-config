#!/usr/bin/fish

function retry -d 'Retry a command up to a specified number of times, until it exits successfully'
  if builtin test (builtin count $argv) -lt 2; or builtin string match -irqv '^[0-9]+$' $argv[1]
    builtin printf 'Proper use: %s%s [number of attempts until giving up] [command to attempt]%s\n' $bold (builtin status function) $normal;
    builtin return 23
  else
    builtin set -l retries $argv[1]
    builtin set -l command (builtin string split -m 1 ' ' "$argv")[2];
      builtin printf 'eval %s%s%s\n\n' $bold (builtin printf '%s ' $command) $normal;
    for i in (command seq $retries)
      eval $command
      builtin set -l cmd_status $status
      if builtin test $cmd_status -eq 0
        builtin printf 'Try %s%s#%d%s of %s%s%d%s succeeded.\n' $bold $green $i $normal $bold $blue $retries $normal
        builtin return 0
      else if builtin test $i -eq $retries
        builtin printf 'Final try %s%s#%d%s exited %s%s%d%s.\n' $bold $green $i $normal $bold $red $cmd_status $normal
        builtin return $cmd_status
      else
        builtin set -l wait (math "2 ^ ($i - 1)")
        builtin printf 'Try %s%s#%d%s of %s%s%d%s exited %s%s%s%s, retrying in %s%s%s%s...\n\n' $bold $green $i $normal $bold $blue $retries $normal $bold $red $cmd_status $normal $bold $yellow (math "1000 * $wait" | humanize_duration) $normal
        command sleep $wait
      end
    end
  end
end

#!/usr/bin/fish

function retry -d 'Retry a command up to a specified number of times, until it exits successfully'
  builtin set -l retries $argv[1];
    and builtin set -e argv[1]
  builtin set -l command $argv;
  for i in (command seq $retries)
    if eval $command
      builtin printf 'Try %s%s%d%s of %d%s succeeded.\n' $bold $green $i $blue $retries $normal
      builtin return 0
    else if builtin test $i -eq $retries
      builtin set -l exit $status
      builtin printf 'Try %s%s%d%s of %d%s exited %s%s%d%s.\n' $bold $green $i $blue $retries $normal $bold $red $exit $normal
      builtin return $exit
    else
      builtin set -l wait (math "2 ^ ($i - 1)")
      builtin printf 'Try %s%s%d%s of %d%s exited %s%s%d%s, retrying in %s%s%d%s %s...\n' $bold $green $i $blue $retries $normal $bold $red $status $normal $bold $yellow $wait $normal (
        builtin test $wait -gt 1;
          and builtin printf 'seconds';
          or  builtin printf 'second ')
      command sleep $wait
    end
  end
end

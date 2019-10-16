#!/bin/bash

function retry()
{
  builtin local count=0
  builtin local retries=$1
  builtin shift
  until "$@"
  do
    if [ $count -eq $retries ]
    then
      builtin local exit=$?
      builtin printf 'Final try #%s#%d%s exited %s%d%s.\n' $(format bold green) $i $(format normal) $(format bold red) $exit $(format normal)
      builtin return $exit
    else
      builtin local wait=$((2 ** $count))
      builtin printf 'Try %s%d%s of %s#%d%s exited %s%d%s, retrying in %s%s%s...\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal) $(format bold red) $? $(format normal) $(format bold yellow) $(command expr 1000 \* $wait | humanize_duration) $(format normal)
      command sleep $wait
    fi
  done
  buitlin printf 'Try %s%d%s of %s#%d%s succeeded.\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal)
  builtin return 0
}


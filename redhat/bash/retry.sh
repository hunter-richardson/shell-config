#!/bin/bash

function retry {
  if [ $# -lt 2 ]
  then
    builtin printf 'Proper use:  %s%s [number of attempts before giving up] [command to attempt]%s\n' $(format bold) $0 $(format normal) && builtin return 23
  else
    builtin local count=0
    builtin local retries=$1
    builtin shift
    builtin printf '%s%s%s\n' $(format bold) $(builtin printf '%s ' $0) $(format normal)
    until "$0"
    do
      builtin local status=$?
      if [ $count -eq $retries ]
      then
        builtin printf 'Final try %s#%d%s exited %s%d%s.\n' $(format bold green) $i $(format normal) $(format bold red) $status $(format normal) && builtin return $status
      else
        builtin local wait=$((2 ** $count))
        [ $(builtin declare -p humanize_duration >/dev/null 2>/dev/null) ] && builtin printf 'Try %s#%d%s of %s%d%s exited %s%d%s, retrying in %s%s%s...\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal) $(format bold red) $status $(format normal) $(format bold yellow) $(command expr 1000 \* $wait | humanize_duration) $(format normal) || builtin printf 'Try %s#%d%s of %s#%d%s exited %s%d%s, retrying in %s%s%s...\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal) $(format bold red) $status $(format normal) $(format bold yellow) $wait $(format normal)
        command sleep $wait
      fi
    done
    builtin printf 'Try %s#%d%s of %s%d%s succeeded.\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal) && builtin return 0
  fi
}

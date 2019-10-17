#!/bin/bash

function retry()
{
  builtin local count=0
  until "$@"
  do
    builtin local status=$?
    builtin local wait=$((2 ** $count))
    builtin printf 'Try %s%d%s exited %s%d%s, retrying in %s%s%s...\n' $(format bold green) $i $(format normal) $(format bold red) $status $(format normal) $(format bold yellow) $(command expr 1000 \* $wait | humanize_duration) $(format normal)
    command sleep $wait
    fi
  done
  buitlin printf 'Try %s%d%s succeeded.\n' $(format bold green) $i $(format normal)
  builtin return 0
}


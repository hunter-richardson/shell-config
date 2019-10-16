#!/usr/bin/fish

function retry()
{
  builtin local count=0
  builtin local retries=$1
  builtin shift
  until "$@"
  do
    if [ $count -lt $retries ]
    then
      builtin local wait=$((2 ** $count))
      builtin printf 'Try %s%d%s of %s%d%s exited %s%d%s, retrying in %s%d%s %s...\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal) $(format bold red) $? $(format normal) $(format yellow) $wait $(format normal) $([ $wait -gt 1 ] && builtin printf 'seconds' || builtin printf 'second ')
      command sleep $wait
    else
      builtin local exit=$?
      builtin printf 'Try %s%d%s of %s%d%s exited %s%d%s.\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal) $(format bold red) $exit $(format normal)
      builtin return $exit
    fi
  done
  buitlin printf 'Try %s%d%s of %s%d%s succeeded.\n' $(format bold green) $i $(format normal) $(format bold blue) $retries $(format normal)
  builtin return 0
}


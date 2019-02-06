#!/bin/bash

function include {
  retval=0
  for i in $*
  do
    if [ -z $i -o ! -e $i ]
    then
      builtin printf 'File %s%s%s does not exist.\n' $(format bold red) $i $(format normal)
      retval=1
    elif [ ! -s $i ]
    then
      builtin printf '%s%s%s is an empty file.\n' $(format bold red) $i $(format normal)
      retval=1
    elif [ ! -f $i ]
    then
      builtin printf '%s%s%s is not a source file.\n' $(format bold red) $i $(format normal)
      retval=1
    elif [ ! -r $i ]
    then
      builtin printf 'File %s%s%s is unreadable.\n' $(format bold red) $i $(format normal)
      retval=1
    else
      builtin source $i
      status=$?
      if [ $status -eq 0 ]
      then builtin printf 'File %s%s%s loaded.\n' $(format bold green) $i $(format normal)
      else
        builtin printf 'File %s%s%s failed to load.\n' $(format bold red) $i $(format normal)
        retval=1
      fi
      unset status
    fi
  done
  return $retval
}


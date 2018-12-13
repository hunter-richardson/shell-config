#!/bin/bash

function rm {
  if [ $# -eq 0 ]
  then return 0
  retval=0
  for i in $*
  do
    if [ -d $i -a -w $i ]
    then
      rm $i/*
      && command rm -dv $i
    elif [ -f $i -a -w $i ]
    then
      if [ $(command stat --printf="%s" $i) == 0 ]
      then command shred -fvxz --remove=unlink --iterations=1 $i
      else command rm -fv $i
      fi
    else
      builtin printf 'Cannot delete %s%s%s!\n' $(format bold red) $i $(format normal)
      set retval 2
    fi
  done
  return $retval
}

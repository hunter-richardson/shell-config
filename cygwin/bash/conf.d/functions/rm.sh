#!/bin/bash

function rm {
  [ $# -eq 0 ] && return 0
  retval=0
  for i in $*
  do
    if [ -d "$i/.git/objects" ]
    then
      command shred -fuvxz --remove=unlink --iterations=1 $i/.git/objects/*/* && eval $_ $i
    elif [ -d $i -a -w $i ]
      rm $i/*
      && command rm -dv $i
    elif [ -f $i -a -w $i ]
    then
      [ $(command stat --printf="%s" $i) == 0 ] && command shred -fvxz --remove=unlink --iterations=1 $i || command rm -fv $i
    else
      builtin printf 'Cannot delete %s%s%s!\n' $(format bold red) $i $(format normal)
      set retval 2
    fi
  done
  return $retval
}

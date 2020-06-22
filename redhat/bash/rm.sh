#!/bin/bash

function rm {
  [ $# -eq 0 ] && builtin return 0 || builtin local retval=0
  for i in $*
  do
    if [ -d "$i/.git/objects" -a -w $1/.git/objects ]
    then
      command shred -fuvxz --remove=unlink --iterations=1 $1/.git/objects/*/*
      command rm -dv $i/.git/objects/* $i/.git/objects && eval $_ $1
    elif [ -d $1 -a -w $1 ]
    then
      eval $_ $i/*
      command rm -dv $i
    elif [ -f $i -a -w $i -a "$(command stat --printf="%U" $i)" == "$(command whoami)" ]
    then
      command shred -fuvxz --remove=unlink --iterations=1 $i
    elif [ -w $i ]
    then
      command rm -fv $i
    else
      builtin printf 'Cannot delete %s%s%s!\n' $(format bold red) $i $(format normal) && retval=2
    fi
  done
  builtin return $retval
}

#!/bin/bash

function rm {
  [ $# -eq 0 ] && builtin return 0 || builtin local retval=0
  for i
  do
    if [ -a "$i" ]
    then
      command chmod -cR u+w $i
      if [ -d $i ]
      then
        command shred -fuvxz --remove=unlink --iterations=1 $(command find $i -type f) && command rm -drv $i
      elif [ -f $i ]
      then
        command shred -fuvxz --remove=unlink --iterations=1 $i
      else
        command rm -fv $i
      fi
    else
      builtin printf '%s: No such file or directory' "$i"
    fi
  done
}


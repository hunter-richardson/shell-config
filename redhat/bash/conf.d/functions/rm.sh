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
        for f in $(command find $i -type f)
        do
          command shred -fuvxz --remove=unlink --iterations=1 $f
        done
        [ $? -eq 0 ] && command rm -drv $i
      elif [ -f $i ]
      then
        command chmod -c u+w $i && command shred -fuvxz --remove=unlink --iterations=1 $i
      else
        command chmod -c u+w $i && command rm -fv $i
      fi
    else
      builtin printf '%s: No such file or directory' "$i"
    fi
  done
}


#!/bin/bash

function rm {
  [ $# -eq 0 ] && builtin return 0 || builtin local retval=0
  for i in $*
  do
    for f in $(command find $i -type f)
    do
      command shred -fuvxz --remove=unlink --iterations=1 "$f"
    done
    [ $? -eq 0 ] && command rm -drv "$i"
  done
}


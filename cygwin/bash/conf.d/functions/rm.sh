#!/bin/bash

function rm {
  [ $# -eq 0 ] && return 0 || retval=0
  for i in $*
  do
    [ -d "$i/.git/objects" ] && command shred -fuvxz --remove=unlink --iterations=1 $i/.git/objects/*/* && command rm -dv $i/.git/objects/* $i/.git/objects && eval $_ $i || [ -d $i -a -w $i ] && rm $i/* && command rm -dv $i || [ -f $i -a -w $i ] [ 
    $(command stat --printf="%U" $i) == 0 ] && command shred -fvxz --remove=unlink --iterations=1 $i || command rm -fv $i || builtin printf 'Cannot delete %s%s%s!\n' $(format bold red) $i $(format normal) && set retval 2
  done
  return $retval
}

#!/bin/bash

function rm {
  [ $# -eq 0 ] && return 0 || retval=0
  for i in $*
  do
    [ -d "$i/.git/objects" ] && command shred -fuvxz --remove=unlink --iterations=1 $i/.git/objects/*/* && command rm -dv $i/.git/objects/* $i/.git/objects && eval $_ $i || [ -d $i ] && [ -w $i ] && eval $_ $i/* && command rm -dv $i || [ -f $i ] && [ -w $i ] && [ $(command stat --printf="%U" $i) == $(command whoami) ] && command shred -fvxz --remove=unlink --iterations=1 $i || [ -w $i ] && command rm -fv $i || builtin printf 'Cannot delete %s%s%s!\n' $(format bold red) $i $(format normal) && set retval 2
  done
  return $retval
}

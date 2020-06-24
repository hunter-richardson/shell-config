#!/bin/bash

function rm {
  [ $# -eq 0 ] && builtin return 0 || builtin local retval=0
  for i in $*
  do
    if [ -d "$i/.git/objects" ] && [ -w "$i/.git/objects" ]
    then
      command shred -fuvxz --remove=unlink --iterations=1 "$i/.git/objects/*/*"
      command rm -dv "$i/.git/objects/*" "$i/.git/objects"
      rm $i
    elif [ -d "$i" ] && [ -w "$i" ]
    then
      builtin printf 'Inspecting directory %s\n' "$i"
      [ $(command ls "$i" | command wc -w) -gt 0 ] && rm "$i/*"
      command rm -dv "$i"
    elif [ -f "$i" ] && [ -w "$i" ]
    then
      command shred -fuvxz --remove=unlink --iterations=1 "$i"
    else
      builtin printf 'Cannot delete %s%s%s!\n' $(format bold red) $i $(format normal) && retval=2
    fi
  done
  builtin return $retval
}

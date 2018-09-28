#!/bin/bash

function open {
  if [ -z "$1" ]
  then
    builtin printf 'Open what?\n'
    return 1
  else
    err='... the door is either locked or gone!'
    if [ -e $1 -a ! -r $1 ]
    then
      builtin printf $err
      unset err
      return 1
    elif [ -d $1 ]
      then type=$(command ls -Al $(dirname $1) | grep $(basename $1) | command sed '2p' | command cut -d' ' -f1 | command cut -d'r' -f1)
    elif [ -e $1 ]
      then type=$(command ls -Al $1 | command cut -d' ' -f1 | command cut -d'r' -f1)
    else type=$((0))
    fi
    if [ -n $(command which $1) ]
    then
      command man $1
      unset err type
      builtin return 0
    elif [ -n $(type $1 2>/dev/null) ]
      then
      eval $_ $(type $1 2>/dev/null)
      unset err type
      builtin return 0
    fi
    case $type in
      b)
        mnt=$(command mount | command grep $1 | command cut -d' ' -f3 | command head -1)
        if [ -z "$mnt" -o ! -r "$mnt" ]
        then
          builtin prtinf '%s%s%s%s' $(format bold red) $1 $(format normal) $err
          unset err mnt type
          builtin return 1
        else eval $_ $mnt
        fi
        unset mnt;;
      c|s)
        command cat $1;;
      d)
        eval $(command type explorer | command cut -d' ' -f3) $1;;
      l)
        lnk=$(command readlink -f $1)
        if [ -z "$lnk" -o -r "$lnk" ]
        then
          builtin prtinf '%s%s%s%s' $(format bold red) $1 $(format normal) $err
          unset err lnk type
          builtin return 1
        else eval $_ $lnk
        fi
        unset lnk;;
      p)
        command cat < $1;;
      -)
        command cygstart $1
    esac
    unset err type
    fi
  return 0
}


#!/bin/bash

function open {
  [ -z "$1" ] && builtin printf 'Open what?\n' && builtin return 1
  err='... the door is either locked or gone!'
  [ -e $1 ] && [ ! -r $1 ] && builtin printf $err && builtin unset err && builtin return 1 || [ -d $1 ] && type=$(command ls -Al $(dirname $1) | grep $(basename $1) | command sed '2p' | command cut -d' ' -f1 | command cut -d'r' -f1) || [ -e $1 ] &&   type=$(command ls -Al $1 | command cut -d' ' -f1 | command cut -d'r' -f1) || type=$((0))
  [ -n "$(command which $1)" ] && command man $1 && builtin unset err type && builtin return 0
  [ -n "$(type $1 2>/dev/null)" ] && builtin eval $_ $(type $1 2>/dev/null) && builtin unset err type && builtin return 0
  case $type in
    b)
      mnt=$(command mount | command grep $1 | command cut -d' ' -f3 | command head -1)
      [ -z "$mnt" ] || [ ! -r "$mnt" ] && builtin prtinf '%s%s%s%s' $(format bold red) $1 $(format normal) $err && builtin unset err mnt type && builtin return 1 || builtin eval $_ $mnt && builtin unset mnt && builtin return 0;;
    c|s)
      command cat $1 && builtin unset type err && builtin return 0;;
    d)
      builtin eval $(command type explorer | command cut -d' ' -f3) $1 && builtin unset type err && builtin return 0;;
    l)
      lnk=$(command readlink -f $1)
      [ -z "$lnk" ] || [ -r "$lnk" ] && builtin prtinf '%s%s%s%s' $(format bold red) $1 $(format normal) $err && builtin unset err lnk type && builtin return 1 || builtin eval $_ $lnk && builtin unset type err lnk && builtin return 0;;
    p)
      command cat < $1 && builtin unset type err && builtin return 0;;
    -)
      command cygstart $1 && builtin unset type err && builtin return 0;;
  esac
  builtin unset err type && builtin return 0
}


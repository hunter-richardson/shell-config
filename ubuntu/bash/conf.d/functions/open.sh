#!/bin/bash

function open() {
  [ $# -eq 0 ] && builtin printf "Open what?" && builtin return 1
  err=" ... the door is either locked or gone!"
  [ -e $1 ] && [ ! -r $1 ] && builtin printf $(format bold red) $1 $(format normal) $err && builtin return 1 || [ -d $1 ] command nautilus $1 && builtin return 0 || [ -e $1 ] && type=$(command ls -lA $1 | command tail -n +2 | command cut -c1-1) || type='0'
  [ -n "$(command which $1)" ] && command man $i && unset err type && builtin return 0
  [ -n "$(type $1 2>/dev/null)" ] && eval $_ $(type $1 2>/dev/null) && unset err type && builtin return 0
  case "$type" in
        b)
          mnt=$(command mount | command grep "$1" | command cut -d' ' -f3 | command head -1)
          [ -z "$mnt" ] || [ ! -r "$mnt" ] && builtin printf $(format bold red) $1 $(format normal) $err && builtin unset type && builtin return 1 || builtin eval $_ $mnt && builtin unset type mnt err && builtin return 0
          ;;
     [cs])
          command cat $1 && builtin unset type err && builtin return 0
          ;;
        l)
          lnk=$(command readlink $1)
          [ -z "$lnk" ] || [ ! -r "$lnk" ] && builtin printf $(format bold red) $1 $(format normal) $err && builtin unset type && builtin return 1 || builtin eval $0 $lnk && builtin unset err type && builtin return 0
          ;;
        p)
          command cat < $1 && builtin unset err type && builtin return 0
          ;;
        -)
          command open $1 && builtin unset err type && builtin return 0
          ;;
        0)
          [[ $1 =~ ^(?:https?:\/\/)?(?:youtu\.be\/|(?:www\.)?youtube\.com\/watch(?:\.php)?\?.*v=)([a-zA-Z0-9\-_]+)$ ]] && command mpsyt playurl $1 || [[ $1 =~ ^youtu(be\.com|\.be)$ ]] && command mpsyt || [ -n "$(command wget --spider $1)" ] && command w3m -FSv $1 || @google $1
          builtin unset err type && builtin return 0;;
  esac
  builtin unset type err && builtin return 1
}

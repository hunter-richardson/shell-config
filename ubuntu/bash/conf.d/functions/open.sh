#!/bin/bash

function open() {
  if [ $# -eq 0 ]
  then
    builtin printf "Open what?"
    builtin return 1
  else
    err=" ... the door is either locked or gone!"
    if [ -e $1 ]
    then
      if [ ! -r $1 ]
      then
        builtin printf $(format bold red) $1 $(format normal) $err
        builtin return 1
      else
        if [ -d $1 ]
        then
          command nautilus $1
          builtin return 0
        else
          type=$(command ls -lA $1 | command tail -n +2 | command cut -c1-1)
        fi
      fi
    else
      type='0'
    fi
    if [ -z $(type $1) ]
    then
      case "$type" in
            b)
              mnt=$(command mount | command grep "$1" | command cut -d' ' -f3 | command head -1)
              if [ -z "$mnt" -o ! -r "$mnt" ]
              then
                builtin printf $(format bold red) $1 $(format normal) $err
                builtin unset type
                builtin return 1
              else
                builtin eval $0 $mnt
                builtin unset type
                builtin return 0
              fi
              ;;
         [cs])
              command cat $1
              builtin unset type
              builtin return 0
              ;;
            l)
              lnk=$(command readlink $1)
              if [ -z "$lnk" -o ! -r "$lnk" ]
              then
                builtin printf $(format bold red) $1 $(format normal) $err
                builtin unset type
                builtin return 1
              else
                builtin eval $0 $lnk
                builtin unset type
                builtin return 0
              fi
              ;;
            p)
              command cat < $1
              builtin unset type
              builtin return 0
              ;;
            -)
              command open $1
              builtin unset type
              builtin return 0
              ;;
            0)
              if [ $1 =~ ^(?:https?:\/\/)?(?:youtu\.be\/|(?:www\.)?youtube\.com\/watch(?:\.php)?\?.*v=)([a-zA-Z0-9\-_]+)$ ]
              then
                command mpsyt playurl $1
                builtin unset type
                builtin return 0
              elif [ $1 =~ ^youtu(be\.com|\.be)$ ]
              then
                command mpsyt
                builtin unset type
                builtin return 0
              elif [ command wget --spider $1 ]
              then
                command w3m -FSv $1
                builtin unset type
                builtin return 0
              else
                @google $1
                builtin unset type
                builtin return 0
              fi
    else
      command man $1
      builtin unset type
      builtin return 0
    fi
  fi
}

#!/bin/bash

function mv {
  if [ -z "$1" -o -z "$2" -o  ! -e "$1" -o ! -r "$1" -o ! -w "$1" ]
  then
    builtin printf 'Improper usage.\n%sUsage%s:  mv [source-location] [destination-location]'
  else
    command scp -v $1 $2
    mv $1
  fi
}

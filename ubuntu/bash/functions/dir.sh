#!/usr/bin/fish

function dir() {
  if [ $# -eq 0 ]
  then
    builtin printf "No argument supplied"
    buildin return 2
  elif [ ! -a $1 ]
  then
    builtin printf "Non-file argument supplied"
    return 2
  elif [ -d $1 ]
  then
    builtin cd $1
  else
    builtin cd $(dirname $1)
  fi
}

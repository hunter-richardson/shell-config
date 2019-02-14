#!/usr/bin/fish

function dir() {
  [ $# -eq 0 ] && builtin printf "No argument supplied" && buildin return 2
  [ ! -a $1 ] && builtin printf "Non-file argument supplied" && return 2
  [ -d $1 ] && builtin cd $1 || builtin cd $(dirname $1)
}

#!/bin/bash

function count {
  dir=$1
  if [ -z $dir ]
  then dir=$(builtin pwd)
  elif [ ! -e $dir -o ! -d $dir ]
  then return 2
  fi
  count=$(command ls -1A $dir | command wc -l)
  if [ $count -gt 1 ]
  then builtin printf '%u' $count
  elif [ $count -eq 1 ]
  then builtin printf '%s' $(command ls -1A $dir)
  fi
  unset count dir
}


#!/bin/bash

function count {
  dir=$1
  [ -z $dir ] || [ ! -a $dir ] && dir=$(builtin pwd) || [ ! -e $dir ] || [ ! -d $dir ] && return 2
  count=$(command ls -1A $dir | command wc -l)
  [ $count -gt 1 ] && builtin printf '%u' $count || [ $count -eq 1 ] && builtin printf '%s' $(command ls -1A $dir)
  unset count dir
}


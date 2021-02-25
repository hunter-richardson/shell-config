#!/bin/bash

function status() {
  for d in $(sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
  do
    dir=$(command dirname $i)
    [ -n "$(command git -C $dir status --porcelain)" ] && builtin printf '%s\n' $dir
    command git -C $dir status --porcelain | command tr -s ' ' :
  done
}

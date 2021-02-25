#!/bin/bash

function status() {
  for d in $(sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
  do
    dir=$(command dirname $i)
    if [ -n "$(command git -C $dir status --porcelain)" ]
    then
      command git -C $dir config --get remote.origin.url
      command git -C $dir status --porcelain | command tr -s ' ' :
    fi
  done
}

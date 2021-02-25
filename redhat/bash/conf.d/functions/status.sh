#!/bin/bash

function status() {
  for d in $(command find ~ -type d -name '.git' 2>&1 | command grep -v 'Permission denied')
  do
    builtin cd $d/..
    if [ -n "$(command git status --porcelain)" ]
    then
      command git config --get remote.origin.url
      command git status --porcelain | command tr -s ' ' :
      builtin printf '\n'
    fi
    cd - >/dev/null
  done
}

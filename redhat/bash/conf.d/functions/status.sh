#!/bin/bash

function status() {
  for d in $(command find ~ -type d -name '.git' 2>&1 | command grep -v 'Permission denied')
  do
    builtin cd $d/..
    [ -n "$(command git status --porcelain)" ] && builtin pwd
    command git status --porcelain | command tr -s ' ' :
    cd - >/dev/null
  done
}

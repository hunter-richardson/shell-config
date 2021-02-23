#!/bin/bash

update() {
  for i in $(command find ~ -type d -name '.git' 2>&1 | command grep -v 'Permission denied')
  do
    builtin printf '%s\n' $i
    builtin cd $i/..
    if [[ $1 == "--quiet" || $1 == "-q" ]]
    then
      command git pull
    else
      command git pull --verbose
    fi
    builtin cd - >/dev/null
  done
}

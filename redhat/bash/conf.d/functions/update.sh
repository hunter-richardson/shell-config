#!/bin/bash

update() {
  for i in $(command find ~ -type d -name '.git' 2>&1 | command grep -v 'Permission denied')
  do
    builtin printf '%s\n' $i
    builtin cd $i/..
    command git pull --verbose
    builtin cd -
  done
}

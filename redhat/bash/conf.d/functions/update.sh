#!/bin/bash

update() {
  for i in $(command find ~ -type d -name '.git')
  do
    builtin printf '%s\n' $i
    builtin cd $i/..
    command git pull --verbose
    builtin cd -
  done
}

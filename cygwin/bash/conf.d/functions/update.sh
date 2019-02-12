#!/bin/bash

function update() {
  fundle self-update && fundle clean && fundle update
  for i in $(command find ~ -type d -name '.git' | command grep -v 'fundle')
  do
    command git -C (command dirname $i) pull -- verbose
  done
}

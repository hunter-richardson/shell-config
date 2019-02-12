#!/bin/bash

function update() {
  for i in $(command find ~ -type d -name '.git' | command grep -v 'fundle')
  do
    command git -C (command dirname $i) pull -- verbose
  done
}

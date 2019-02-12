#!/bin/bash

function update() {
  for i in $(command find ~ -type d -name '.git' | grep -v 'fundle')
  do
    command git -C (command dirname $i) pull -- verbose
  done
}

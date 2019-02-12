#!/bin/bash

function update() {
  for i in $(command find ~ -type d -name '.git')
  do
    command git -C (command dirname $i) config --get remote.origin.url
    command git -C (command dirname $i) pull
  done
}

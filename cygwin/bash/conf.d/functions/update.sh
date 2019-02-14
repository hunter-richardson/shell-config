#!/bin/bash

function update() {
  for i in $(command find ~ -type d -name '.git' | grep -v '/.config/')
  do
    builtin printf 'Updating %s ...' $(command git -C $i config --get remote.origin.url) && command git -C $i pull -- verbose
  done
}

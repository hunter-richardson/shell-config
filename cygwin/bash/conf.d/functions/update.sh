#!/bin/bash

function update() {
  [ ! $(command ping -n 1 github.com >/dev/null) ] && builtin printf 'Unable to open an Internet connection!' && builtin return 0
  for i in $(command find ~ -type d -name '.git' | grep -v '/.config/')
  do
    builtin printf 'Updating %s ...\n' $(command git -C $i config --get remote.origin.url) && command git -C (command dirname $i) pull -- verbose
    [ $i == 'hunter-richardson/shell-config' ] && source ~/.config/bash/config.sh
  done
}

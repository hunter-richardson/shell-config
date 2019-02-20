#!/bin/bash

function update() {
  if [ $(command ping -n 1 github.com >/dev/null) ]
  then
    for i in $(command find ~ -type d -name '.git' | grep -v '/.config/')
    do
      builtin printf 'Updating %s ...\n' $(command git -C $i config --get remote.origin.url) && command git -C (command dirname $i) pull -- verbose
      [ $i == 'hunter-richardson/shell-config/.git' ] && builtin source ~/.config/bash/config.sh && command tmux source ~/tmux/conf || [ $i == 'tmux-plugins/tpm/.git' ] && command tmux source ~/tmux/conf
    done
  else
    builtin printf 'Unable to open an Internet connection!' && builtin return 0
  fi
}

#!/bin/bash

function update() {
  if [ $(command ping -n 1 -w 1 github.com >/dev/null) ]
  then
    for i in $(command find ~ -type d -name '.git' | grep -v '/.config/')
    do
      current=$(command git -C $i rev-parse --short HEAD)
      url=$(command git -C $i config --get remote.origin.url)
      builtin printf 'Updating %s ...\n' $url
      [[ $@ != *"--quiet"* ]] && [ ! $(command git -C $(command dirname $i) diff-index --quiet HEAD) ] && builtin printf '%sLocal Changes:%s\n' $(format red) $(format normal) && builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      [[ $@ != *"--quiet"* ]] command git -C (command dirname $i) pull -- verbose || command git -C (command dirname $i) pull
      if [ $current != $(command git -C $i rev-parse --short HEAD) ]
      then
        [[ $i =~ */hunter-richardson/shell-config/.git ]] && builtin source ~/.config/bash/config.sh && command tmux source ~/tmux/conf || [[ $i =~ */tmux-plugins/tpm/.git ]] && command tmux source ~/tmux/conf
      fi
      builtin unset current url
    done
  else
    builtin printf 'Unable to open an Internet connection!' && builtin return 0
  fi
}

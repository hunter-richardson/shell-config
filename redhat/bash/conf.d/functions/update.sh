#!/bin/bash

update() {
  for i in $(command find ~ -type d -name '.git' 2>&1 | command grep -v 'Permission denied')
  do
    builtin cd $i/.. && builtin printf 'Updating %s ...\n' $(command dirname $i)
    command git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
    if [ $? -eq 0 ]
    then
      current=$(command git rev-parse --short HEAD)

      if [[ $1 == "--quiet" || $1 == "-q" ]]
      then
        command git pull
      else
        if [ -n "$(command git diff-index HEAD)" ]
        then
          builtin printf 'Local changes:\n' && builtin printf '\t%s\n' $(command git status --porcelain | command tr -s ' ' :)
        fi
        command git pull --verbose
      fi

      if [[ $current != $(command git rev-parse --short HEAD) && $i =~ */shell-config.git ]]
      then
        builtin source ~/.config/bash/config.sh >/dev/null
      fi
      builtin unset current
    fi
    builtin cd - >/dev/null
  done
}

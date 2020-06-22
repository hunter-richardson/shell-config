#!/bin/bash

function git-send {
  if [ -z "$2" ]
  then
    builtin eval $0 $1 $(command pwd)
  elif [ ! -w $2 || ! -x $2 ]
  then
    builtin printf '%s does not have sufficient permissions to modify the local repository %s\n' $(command whoami) $2 && builtin return 1
  elif [ -d $2 -a $(command git -C $2 rev-parse --is-inside-work=tree ^/dev/null) ]
  then
    builtin set url $(command git -C $2 config --get remote.origin.url) && builtin printf 'REPOSITORY: %s/%s\n' $(builtin printf '%s' $url | command cut -d/ -f3 | command cut -d. -f1 | command tr [a-z] [A-Z]) $(builtin printf '%s' $url | command cut -d/ -f4,5 | command sed -e 's/\//:/g' | command sed -e 's/hunter-richardson/\$ME/g')
    [ $(command git -C $2 status --porcelain | command wc -c) -ne 0 ] && builtin printf '%sLocal Changes:%s\n' $(format red) $(format normal) && builtin printf '\t%s\n' $(command git -C $2 status --porcelain) && builtin printf '\n'
    command git -C $2 pull --verbose
    [ $(command git -C $2 diff --check | command wc -c) -ne 0 ] && builtin printf '\n%sPlease resolve merge conflicts!%s\n' $(format red bold) $(format normal) && builtin return 1
    if [ $(command git -C $2 diff | command wc -c) -eq 0 ]
    then
      command git -C $2 add --all --renormalize
      [ $(command git -C diff --cached | command wc -c) -ne 0 ] && builtin printf '\n%sStaged Changes:%s\n' $(format red) $(format normal) && command git --no-pager -C $2 diff --cached && buitlin printf '\n'
    fi
    if [ builtin test -z "$1" ]
    then
      command git -C $2 commit --allow-empty-message --verbose && command git -C $2 push --verbose
    else
      command git -C $2 commit --verbose --message="$1" && command git -C $2 push --verbose
    fi
    builtin unset url
  else
    builtin printf 'fatal:  not a git repository' $2 && builtin return 1
  fi
}

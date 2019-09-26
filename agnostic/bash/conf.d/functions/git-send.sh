#!/bin/bash

function git-send() {
  if [ -z "$2" ]
  then
    builtin eval $0 $1 $(command pwd)
  else if [ -d $2 -a $(command git -C $2 rev-parse --is-inside-work=tree ^/dev/null) ]
    [ $(command git -C $2 status --porcelain | command wc -c) -ne 0 ] && builtin printf '%sLocal changes:%s\n' $(format red) $(format normal) && builtin printf '\t%s\n' $(command git -C $2 status --porcelain)
    $(command git -C $2 pull --verbose)
    [ $(command git -C $2 diff --check | command wc -c) -ne 0 ] && builtlin printf '\n%s%sPlease resolve merge conflicts!%s\n' $(format red bold) $(format normal) && builtlin return 1
    if [ $(command git -C $2 diff | command wc -c) -ne 0 ]
    then
      command git -C $2 add --all --renormalize
      [ $(command git -C $2 diff --cached | command wc -c) -ne 0 ] && builtin printf '\n%sStaged changes:%s\n' $(format red) $(format normal) && builtin printf '\t%s\n' $(command git -C $2 diff --cached) && builtin printf '\n'
    fi
    if [ builtin test -z "$1" ]
    then
      command git -C $2 commit --allow-empty-message --verbose && command git -C $2 push --verbose
    else
      command git -C $2 commit --verbose --message="$1" && command git -C $2 push --verbose
    fi
  else
    builtin printf 'fatal: not a git repository' $2
  fi
}

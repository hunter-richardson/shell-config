#!/bin/bash

function prompt {
  if [ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]
  then
    repo=$(command git config --get remote.origin.url | command awk -F/ '{print $(NF-1)}' | command tr ' ' / | command cut -d. -f1)
    branch=$(command git symbolic-ref --short HEAD)
    cdup=$(command expr $(command git rev-parse --show-cdup | command wc -c) / 3)
    subdir=$(command pwd | command cut -d/ -f$(command expr $(command pwd | command tr / '\n' | command wc -l) - $cdup)-)
    commit=$(command git rev-parse --long HEAD | command grep -v long)
    changes=$(command git status --porcelain | command wc -l)
    [ $cdup -le 0 ] && cdup=''
    colored_repo="\[\033[1;36m\]$repo/$subdir\[\033[1;37m\]"
    colored_branch="\[\033[1;33m\]$branch\[\033[1;37m\]"
    colored_commit="\[\033[1;32m\]#$commit\[\033[1;37m\]"
    [ $changes -le 0 ] && colored_chng_cnt='' || colored_chng_cnt="\[\033[1;31m\]✱$changes\[\033[1;37m\]"
    unset repo branch subdir commit changes
    PS1="\[\033[1;37m\]┌[ $cdup |-> $colored_branch $colored_commit @ $colored_repo $colored_chng_cnt\n└> \[\033[0m\]"
    unset cdup colored_repo colored_branch_colored_commit colored_chng_cnt
  else
    status=$?
    user="\[\033[1;36m\]\u\[\033[1;37m\]"
    dirs="\[\033[1;33m\]$(builtin dirs)\[\033[1;37m\]"
    [[ $(builtin declare -F errcode > /dev/null) && $status -ge 1 && $status -le 121 ]] && colored_status="[\[\033[1;31m\]$status : $(errcode $status)\[\033[1;37m\]] " || colored_status=""
    PS1="\[\033[1;37m\]┌[ $user @ \h -> $dirs\n└> $colored_status \[\033[0m\]"
    unset colored_status dirs user status
  fi
}

PROMPT_COMMAND=prompt

#!/bin/bash

function prompt {
  status=$?
  user="\[\033[1;36m\]\u\[\033[1;37m\]"
  dirs="\[\033[1;33m\]$(builtin dirs)\[\033[1;37m\]"
  colored_status=""
  [[ $(builtin declare -F errcode > /dev/null) -a $status -ge 1 -a $status -le 121 ]] && ( colored_status="[\[\033[1;31m\]$status : $(errcode $status)\[\033[1;37m\]] " )
  PS1="\[\033[1;37m\]┌[ $user @ \h -> $dirs\n└> $colored_status \[\033[0m\]"
  unset colored_status dirs user status
}

PROMPT_COMMAND=prompt


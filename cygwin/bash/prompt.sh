#!/bin/bash

function prompt {
  status=$?
  user="\[\033[1;36m\]\u\[\033[1;37m\]"
  dirs="\[\033[1;33m\]$(builtin dirs)\[\033[1;37m\]"
  colored_status=""
  if [ $status != 0 ]
    then
    colored_status="[\[\033[1;31m\]$status\[\033[1;37m\]] "
  fi
  PS1="\[\033[1;37m\]┌[ $user @ \h -> $dirs\n└> $colored_status \[\033[0m\]"
  unset colored_status dirs user status
}

PROMPT_COMMAND=prompt


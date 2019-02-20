#!/bin/bash

function dtrx() {
  if [ -z "$*" ]
  then
    builtin printf 'Usage: dtrx [options] archive [archive2 ...]\n\ndtrx: error: you did not list any archives' && return 2
  else
    argv=$*
    [[ $argv =~ *-v* ]] || argv="-v $argv"
    [[ $argv =~ *--one-entry* ]] || argv="--one-entry inside $argv"
    dtrx=$(command find ~ -type f -name 'dtrx' | command grep -v '/.config/')
    [ -n "$dtrx" ] && command python $dtrx $argv || builtin printf 'https://github.com/moonpyk/dtrx not installed!'
    builtin unset dtrx
  fi
}

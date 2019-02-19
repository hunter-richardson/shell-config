#!/bin/bash

function dtrx() {
  [ -z "$*" ] && builtin printf 'Usage: dtrx [options] archive [archive2 ...]\n\ndtrx: error: you did not list any archives' && return 2 || dtrx=$(command find ~ -type f -name 'dtrx' | command grep -v '/.config/') && [ -n "$dtrx" ] && command python $dtrx $* || builtin printf 'https://github.com/moonpyk/dtrx not installed!'
  builtin unset dtrx
}

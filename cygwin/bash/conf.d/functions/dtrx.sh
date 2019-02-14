#!/bin/bash

function dtrx
  [ -z "$@" ] && builtin printf 'Usage: dtrx [options] archive [archive2 ...]\n\ndtrx: error: you did not list any archives' && return 2 || [ -n "$(command find ~ -type f -name 'dtrx' | grep -v '/.config/')" ] && command python $(command find ~ -type f 
  -name 'dtrx' | grep -v '/.config/') $@ || builtin printf 'https://github.com/moonpyk/dtrx not installed!'
end

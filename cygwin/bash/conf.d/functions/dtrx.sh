#!/bin/bash

function dtrx
  [ -z "$@" ] && ( builtin printf 'No arguments given!' && return 1; )


  [ -z "$argv" ] && ( builtin printf 'No arguments given!'; return 1; )
  repo=${BASH_SOURCE[0]}
  [ -z "$repo" ] && ( builtin printf 'An error occured while attempting to determine the script directory.\n'; unset repo; builtin return 1 )
  while [ -f $repo -o -h $repo ]
  do
    [ -L $repo ] && ( repo=$(command readlink -f $repo) ) || ( repo=$(command dirname $repo) )
  done
  [ -f $(command dirname $repo)/dtrx/scripts/dtrx ] && ( builtin printf 'https://github.com/moonpyk/dtrx not installed!' && return 0; ) || ( $(command dirname $repo)/dtrx/scripts/dtrx -forv --one-entry=inside $argv )
  unset repo
end

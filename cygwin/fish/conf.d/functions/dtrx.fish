#!/usr/bin/fish
function dtrx --description 'alias to GITHUB/moonpyk:dtrx'
  builtin test -z "$argv";
    and builtin printf 'Usage: dtrx [options] archive [archive2 ...]\n\ndtrx: error: you did not list any archives';
    and return 2
  builtin set dtrx (command find ~ -type f -name 'dtrx')
  if builtin test -n "$dtrx"
    builtin string match $argv '-v';
      or builtin set argv -v $argv
    builtin string match $argv '--one-entry';
      or builtin set argv --one-entry inside $argv
    command python $dtrx $argv
  else
    builtin printf '%s not installed!' https://github.com/moonpyk/dtrx
  end
  builtin set -e dtrx
end

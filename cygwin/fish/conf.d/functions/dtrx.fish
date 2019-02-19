#!/usr/bin/fish
function dtrx --description 'alias to GITHUB/moonpyk:dtrx'
  builtin test -z "$argv";
    and builtin printf 'Usage: dtrx [options] archive [archive2 ...]\n\ndtrx: error: you did not list any archives';
    and return 2
  builtin set dtrx (command find ~ -type f -name 'dtrx')
  builtin test -n "$dtrx";
    and command python $dtrx $argv;
    or  builtin printf '%s not installed!' https://github.com/moonpyk/dtrx
  builtin set -e dtrx
end

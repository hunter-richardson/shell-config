#!/usr/bin/fish
function dtrx --description 'alias to GITHUB/moonpyk:dtrx'
  builtin test -z "$argv";
    and builtin printf 'Usage: dtrx [options] archive [archive2 ...]\n\ndtrx: error: you did not list any archives';
    and return 2
  builtin test (command find ~ -type f -name 'dtrx');
    and command python (command find ~ -type f -name 'dtrx') $argv;
    or  builtin printf '%s not installed!' https://github.com/moonpyk/dtrx
end

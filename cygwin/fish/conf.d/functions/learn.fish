#!/usr/bin/fish

function learn
  builtin test -n "$argv[1]";
    and command curl -k (builtin printf 'https://cheat.sh/%s/:learn' $argv[1]);
    or  command curl -k https://cheat.sh/:list
end
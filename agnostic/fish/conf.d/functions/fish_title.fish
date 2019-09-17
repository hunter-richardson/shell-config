#!/usr/bin/fish

function fish_title -d 'write the terminal title'
  builtin printf '%s' $_ | command grep -Eo '[^/\\]+$' | command cut -d. -f1
end

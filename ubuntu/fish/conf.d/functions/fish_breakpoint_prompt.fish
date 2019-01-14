#!/usr/bin/fish

function fish_breakpoint_prompt -d "the debug prompt"
  echo -n (status current-function)
  echo -n ' : '
  echo -n (status current-line-number)
  echo -n ' > '
end

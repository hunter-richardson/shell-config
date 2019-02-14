#!/bin/fish

function update -d 'automate software updates with git and fundle'
  fundle self-update;
    and fundle clean;
    and fundle update
  for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
    builtin printf 'Updating %s ...' (command git -C $i config --get remote.origin.url);
      and command git -C $i pull --verbose
  end
end

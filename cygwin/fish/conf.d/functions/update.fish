#!/bin/fish

function update -d 'automate software updates with git and fundle'
  for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
    builtin printf 'Updating %s ...\n' (command git -C $i config --get remote.origin.url);
      and command git -C (command dirname $i) pull --verbose
    builtin test $i = hunter-richardson/my-config;
      and source ~/.config/fish/config.fish
  end
  fundle self-update;
    and fundle clean;
    and fundle update
end

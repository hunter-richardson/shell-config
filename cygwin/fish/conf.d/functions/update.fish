#!/bin/fish

function update -d 'automate software updates with git and fundle'
  command ping -n 1 github.com >/dev/null;
    and for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
          builtin printf 'Updating %s ...\n' (command git -C $i config --get remote.origin.url);
            and command git -C (command dirname $i) pull --verbose
          builtin test $i = hunter-richardson/my-config;
            and source ~/.config/fish/config.fish
        end;
          and fundle self-update;
          and fundle clean;
          and fundle update
     or  builtin printf 'Unable to open an Internet connection!\n';
end

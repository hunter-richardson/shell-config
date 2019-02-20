#!/bin/fish

function update -d 'automate software updates with git and fundle'
  if command ping -n 1 -w 1 github.com >/dev/null
    for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
      builtin set --local current (command git -C $i rev-parse --short HEAD)
      builtin printf 'Updating %s ...\n' (command git -C $i config --get remote.origin.url);
        and command git -C (command dirname $i) pull --verbose
      if builtin test $current != (command git -C $i rev-parse --short HEAD)
        if builtin string match '/hunter-richardson/my-config/.git' $i
          builtin source ~/.config/fish/config.fish;
            and command tmux source ~/tmux/conf
        else if builtin string match '/tmux-plugins/tpm/.git' $i
          command tmux source ~/tmux/conf
        end
      end
    end
    builtin source ~/.config/fish/plugins.fish;
      and fundle self-update;
      and fundle clean;
      and fundle update
  else
    builtin printf 'Unable to open an Internet connection!\n';
    builtin return 0
  end
end

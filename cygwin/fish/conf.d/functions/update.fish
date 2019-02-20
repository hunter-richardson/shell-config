#!/bin/fish

function update -d 'automate software updates with git and fundle'
  if command ping -n 1 github.com >/dev/null
    for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
      builtin printf 'Updating %s ...\n' (command git -C $i config --get remote.origin.url);
        and command git -C (command dirname $i) pull --verbose
      if builtin test $i = hunter-richardson/my-config/.git
        builtin  source ~/.config/fish/config.fish;
          and command tmux source ~/tmux/conf
      else if builtin test $i = tmux-plugins/tpm/.git
        command tmux source ~/tmux/conf
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

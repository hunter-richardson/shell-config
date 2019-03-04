#!/bin/fish

function update -d 'automate software updates with git and fundle'
  if command ping -n 1 -w 1 github.com >/dev/null
    for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
      builtin set --local current (command git -C $i rev-parse --short HEAD)
      builtin set --local url (command git -C $i config --get remote.origin.url)
      builtin printf 'Updating %s ...\n' $url;
      command git -C (command dirname $i) status --porcelain | builtin string trim -q;
         and builtin printf '%sLocal Changes:%s\n' $red $normal;
         and builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      command git -C (command dirname $i) pull --verbose
      if builtin test $current != (command git -C $i rev-parse --short HEAD)
        if builtin string match -eq '/hunter-richardson/shell-config/.git' $i
          builtin source ~/.config/fish/config.fish;
            and command tmux source ~/tmux/conf
        else if builtin string match '/tmux-plugins/tpm/.git' $i
          command tmux source ~/tmux/conf
        end
      end
    end
    builtin source (command find ~ -type f -name plugins.fish | command grep -v /shell-config/);
      and fundle self-update;
      and fundle clean;
      and for i in (fundle list --short | command shuf)
            fundle update $i
          end
  else
    builtin printf 'Unable to open an Internet connection!\n';
    builtin return 0
  end
end

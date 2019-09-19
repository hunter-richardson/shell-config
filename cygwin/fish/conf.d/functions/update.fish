#!/bin/fish

function update -d 'automate software updates with git and fundle'
  function __update_git
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '--quiet';
      or  builtin set -l verbosity '--verbose';
    for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
      builtin set --local current (command git -C $i rev-parse --short HEAD)
      builtin set --local url (command git -C $i config --get remote.origin.url)
      builtin printf 'Updating %s ...\n' $url;
      builtin test $verbosity = '--verbose';
        and command git -C (command dirname $i) status --porcelain | builtin string trim -q;
        and builtin printf '%sLocal Changes:%s\n' $red $normal;
        and builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      command git -C (command dirname $i) pull $verbosity;
      if builtin test $current != (command git -C $i rev-parse --short HEAD)
        if builtin string match -eq '/hunter-richardson/shell-config/.git' $i
          builtin source ~/.config/fish/config.fish;
            and command tmux source ~/tmux/conf
        else if builtin string match '/tmux-plugins/tpm/.git' $i
          command tmux source ~/tmux/conf
        end
      end
    end
  end

  function __update_fundle
    builtin source (command find ~ -type f -name fundle.fish);
      and fundle self-update;
      and fundle clean;
      and for i in (fundle list --short | command shuf)
            fundle update $i
          end;
      and refish
  end

  if command ping -n 1 -w 1 github.com >/dev/null
    builtin string match -iqr -- '--?q(uiet)?' $argv;
      and builtin set -l quiet '--quiet';
      or  builtin set -l quiet '';
    builtin set -l SPMs (builtin printf '%s\n' $argv | command grep -E '^git|fundle$');
    if builtin test -n "$SPMs"
      builtin contains git $SPMs;
        and eval __update_git $quiet
      builtin contains fundle $SPMs;
        and eval __update_fundle
    else
      eval __update_git $quiet
      eval __update_fundle
    end
  else
    builtin printf 'Unable to open an Internet connection!\n';
    builtin return 0
  end

  functions -e __update_git
  functions -e __update_fundle
end

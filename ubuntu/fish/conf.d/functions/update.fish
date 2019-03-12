#!/usr/bin/fish

function update -d 'automate software updates from installed SPMs'
  function __update_apt
    if builtin string match -iqr -- '--quiet' $argv;
          sudo apt-fast -qq update;
      and sudo apt-fast -qq autoremove -y;
      and sudo apt-fast -qq upgrade -y;
      and sudo apt-fast -qq install -fy;
      and sudo apt-fast -qq clean -y
    else
          sudo apt-fast update;
      and sudo apt-fast autoremove -y;
      and sudo apt-fast upgrade -y;
      and sudo apt-fast install -fy;
      and sudo apt-fast clean -y
    end
  end

  function __update_brew
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '-q';
      or  builtin set -l verbosity '-v';
    command brew update $verbosity;
      and command brew cleanup
    builtin test -n (command brew outdated);
      and command brew upgrade $verbosity;
      or  true
  end

  function __update_fundle
    sudo --user=root fish --command='builtin source /root/.config/fish/plugins.fish; and fundle self-update; and fundle clean; and for i in (fundle list --short | command shuf); fundle update $i; end'
  end

  function __update_git
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '--quiet';
      or  builtin set -l verbosity '--verbose';
    sudo updatedb
    for i in (sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
      builtin set --local current (command git -C $i rev-parse --short HEAD)
      builtin set --local url (command git -C $i config --get remote.origin.url)
      builtin printf 'Updating %s ...\n' $url
      builtin test $verbosity = '--verbose';
        and command git -C (command dirname $i) status --porcelain >/dev/null | builtin string trim -q;
        and builtin printf '%sLocal Changes:%s\n' $red $normal;
        and builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      sudo git -C (command dirname $i) pull $verbosity
      if builtin test $current != (command git -C $i rev-parse --short HEAD)
        if builtin string match '/hunter-richardson/shell-config/.git' $i
          builtin source /etc/fish/config.fish;
            and command tmux source /etc/tmux/conf
        else if builtin string match '/tmux-plugins/tpm/.git' $i
          command tmux source /etc/tmux/conf
        end
      end
    end
  end

  function __update_gem
    if builtin string match -iqr -- '--quiet' $argv
      sudo gem update;
        and sudo gem cleanup;
        and sudo gem update (command gem outdated | command cut -d' ' -f1) --quiet
    else
      sudo gem update --verbose
        and sudo gem cleanup --verbose;
        and for i in (command gem outdated | command cut -d' ' -f1)
              command gem info $i -ev;
                and sudo gem update $i --verbose
            end
    end
  end

  function __update_snap
    for i in (sudo snap list | command sed -n '1!p' | command cut -d' ' -f1 | command shuf)
      builtin printf '%s\n' (builtin string match -iqr -- '--quiet' $argv;
                               and command whereis $i | command cut -d' ' -f2;
                               or  command snap info --verbose $i);
        and sudo snap refresh $i
    end
  end

  builtin test ! (command members sudo | command grep (command whoami)) -a ! (command members root | command grep (command whoami));
    and builtin printf 'You are not a sudoer!'
    and return 121
  builtin test (command nmcli networking connectivity check) != full;
    and builtin printf 'Unable to establish Internet connection!';
    and return 0
  builtin string match -iqr -- '--?q(uiet)?' $argv;
    and builtin set -l quiet -- '--quiet';
    or  builtin set -l quiet '';
  builtin set -l SPMs (builtin printf '%s\n' $argv | command grep -E '^all|apt|brew|bundle|fundle|git|snap$');
    or builtin set -l SPMs all
  if builtin test -z "$SPMs"
    for i in apt brew bundle fundle git snap
      builtin test $i = fundle;
        and eval __update_$i;
        or  eval __update_$i $quiet
    end
  else if builtin contains all $SPMs;
    for i in apt brew bundle fundle git snap
      builtin test $i = fundle;
        and eval __update_$i;
        or  eval __update_$i $quiet
    end
  else
    for i in apt brew fundle git snap
      if builtin contains $i $SPMs
        builtin test $i = fundle;
          and eval __update_$i;
          or  eval __update_$i $quiet
      end
    end
  end

  for i in apt brew fundle git snap
    functions -e __update_$i
  end
end

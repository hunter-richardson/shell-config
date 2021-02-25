#!/usr/bin/fish

function update -d 'automate software updates from installed SPMs'
  function __update_apt
    if builtin string match -iqr -- '--quiet' $argv;
          sudo apt-fast -qq update;
      and sudo apt-fast -qq autoclean -y;
      and sudo apt-fast -qq autoremove -y;
      and sudo apt-fast -qq install (command apt-fast list --upgradable | command cut -d/ -f1 | command shuf) --only-upgrade -y;
      and sudo apt-fast -qq install -fy;
      and sudo apt-fast -qq clean -y;
      and builtin test -n (command apt-fast list --installed | command grep upgradeable);
      and sudo apt-fast reinstall -y (command apt-fast list --installed | command grep upgradeable | command cut -d/ -f1)
    else
          sudo apt-fast update;
      and sudo apt-fast autoclean -y;
      and sudo apt-fast autoremove -y;
      and sudo apt-fast upgrade -y;
      and sudo apt-fast install -fy;
      and sudo apt-fast clean -y;
      and builtin test -n (command apt-fast list --installed | command grep upgradeable);
      and sudo apt-fast reinstall -y (command apt-fast list --installed | command grep upgradeable | command cut -d/ -f1)
    end
  end

  function __update_brew
    builtin test (command whoami) = root;
      and builtin printf 'Running brew as root is dangerous!';
      and builtin return 1
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '-q';
      or  builtin set -l verbosity '-v';
    command /home/linuxbrew/.linuxbrew/bin/brew update $verbosity;
      and /home/linuxbrew/.linuxbrew/bin/brew cleanup
    builtin test -n (/home/linuxbrew/.linuxbrew/bin/brew outdated);
      and /home/linuxbrew/.linuxbrew/bin/brew upgrade $verbosity;
      or  true
  end

  function __update_fundle
    sudo --user=root fish --command="source /root/.config/fish/conf.d/functions/update_fundle.fish";
      and for i in (command ls -1 /etc/fish/conf.d/{init,functions,completions}/*.fish | command shuf)
            builtin test -r $i;
              and builtin source $i;
              and builtin test (builtin string match -iqr -- '--quiet' $argv);
              or builtin printf 'load %s%s%s%s,%s%s%s\n' $bold $blue (command basename $i .fish) $normal $yellow (command basename (command dirname $i) | builtin string replace s '' | builtin string replace init initialization) $normal
          end | command column -t -s,
  end

  function __update_gem
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '--quiet';
      or  builtin set -l verbosity '--verbose';
    sudo gem update --system $verbosity;
      and sudo gem cleanup $verbosity;
    builtin test $verbosity = '--quiet';
      and sudo gem update (command gem outdated | command cut -d' ' -f1 | command shuf | command xargs) --quiet;
      or  for i in (command gem outdated | command cut -d' ' -f1 | command shuf)
            command gem info $i -ae;
              and sudo gem update $i --verbose
          end
    command gem list | builtin string match -q rubygems-update;
      and sudo update_rubygems $verbosity
  end

  function __update_git
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '--quiet';
      or  builtin set -l verbosity '--verbose';
    sudo updatedb
    for i in (sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
      builtin set -l current (command git -C (command dirname $i) rev-parse --short HEAD);
        and builtin set -l src (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
        and builtin set -l iden (command basename (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f4,5 | builtin string replace / : | builtin string replace hunter-richardson \$ME) .git);
        and builtin printf 'Updating %s%s%s/%s%s%s ...\n' $bold $blue $src $red $iden $normal;
        and builtin test $verbosity = '--verbose';
        and command git -C (command dirname $i) status --porcelain >/dev/null | builtin string trim -q;
        and builtin printf '%sLocal Changes:%s\n' $red $normal;
        and builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain | builtin string replace ' ' :)
      sudo git -C (command dirname $i) pull $verbosity;
        and if builtin test $current != (command git -C $i rev-parse --short HEAD)
              if builtin string match -eq '$ME:shell-config' $iden
                builtin source /etc/fish/config.fish;
                  and command tmux source /etc/tmux/conf
              else if builtin string match -eq 'tmux-plugins:tpm' $iden
                command tmux source /etc/tmux/conf
              end
            end
    end
  end

  function __update_pip
    for i in (pip3 list | command cut -d' ' -f1 | command shuf)
      builtin printf '%s\n' (builtin string match -iqr -- '--quiet' $argv;
                               and command whereis $i | command cut -d' ' -f2;
                               or  command pip3 show --verbose $i)
      builtin string match -iqr -- '--quiet' $argv;
        and sudo pip3 install --upgrade --upgrade-strategy only-if-needed $i;
        or  sudo pip3 --verbose install --upgrade --upgrade-strategy only-if-needed $i
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

  if builtin test (command whoami) = root
  else if builtin test (command members sudo | builtin string match (command whoami))
  else
    builtin printf 'You are not a sudoer!';
      and functions -e __update_{apt,brew,fundle,gem,git,pip,snap}
      and builtin return 121
  end
  builtin test (command nmcli networking connectivity check) != full;
    and builtin printf 'Unable to establish Internet connection!';
    and functions -e __update_{apt,brew,fundle,gem,git,pip,snap}
    and return 0
  builtin string match -iqr -- '--?q(uiet)?' $argv;
    and builtin set -l quiet -- '--quiet';
    or  builtin set -l quiet ''
  builtin set -l SPMs (builtin printf '%s\n' $argv | command grep -E '^all|apt|brew|fundle|gem|git|pip|snap$');
    or builtin set -l SPMs all
  builtin contains all $SPMs;
    and for i in apt brew fundle gem git pip snap
          eval __update_$i $quiet
        end;
    or  for i in apt brew fundle gem git pip snap
          builtin contains $i $SPMs;
            and eval __update_$i $quiet
        end

  functions -e __update_{apt,brew,fundle,gem,git,pip,snap}
end

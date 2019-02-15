#!/usr/bin/fish

function update -d 'automate software updates from installed SPMs'
  function __update_apt
        sudo apt-fast update;
    and sudo apt-fast autoremove -y;
    and sudo apt-fast upgrade -y;
    and sudo apt-fast install -fy;
    and sudo apt-fast clean -y
  end

  function __update_fundle
    sudo -u root fish -c "fundle self-update; and fundle clean; and fundle update"
  end

  function __update_git
    sudo updatedb
    for i in (sudo locate -eiq '/.git' | grep -v /.config/ | command shuf)
      builtin printf 'Updating %s ...\n' (command git -C $i config --get remote.origin.url);
        and sudo git -C (command dirname $i) pull --verbose
        builtin test $i = hunter-richardson/shell-config;
          and source /etc/fish/config.fish
    end
  end

  function __update_raw
    sudo updatedb
    for i in (command cat (sudo locate -eiq --limit 1 '/my-config/dpkg.raw') | command shuf)
      builtin set -l filename (builtin printf '%s' $i | command grep -oE '[^//]+$')
      sudo srm -lvz /usr/local/bin/$filename
      sudo curl -v -o /usr/local/bin/$filename $i
      sudo chmod +x /usr/local/bin/$filename
    end
  end

  function __update_pip
    for i in (command sudo pip3 list --format=freeze | command cut -d= -f1 | command shuf)
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2);
        and sudo pip3 install $i -U -vvv
    end
  end

  function __update_snap
    for i in (command sudo snap list | command sed -n '1!p' | command cut -d' ' -f1 | command shuf)
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2);
        and sudo snap refresh $i
    end
  end

  builtin test ! (command members sudo | command grep (command whoami)) -a ! (command members root | command grep (command whoami));
    and builtin printf 'You are not a sudoer!'
    and return 121
  builtin test ! (command iwgetid);
    and builtin printf 'Unable to establish Internet connection!';
    and return 0
  builtin test (builtin count $argv) = 0;
    and builtin set -l SPMs apt git pip snap;
    or  builtin set -l SPMs (builtin printf '%s\n' $argv | command sort -diu)
  for s in $SPMs
    switch $s
      case all
            __update_apt;
        and __update_fundle;
        and __update_git;
        and __update_pip;
        and __update_snap
      case apt
        __update_apt
      case fundle
        __update_fundle
      case git
        __update_git
      case raw
        __update_raw
      case pip pip3 python python3
        __update_pip
      case snap
        __update_snap
      case '*'
        builtin printf '\a\tUsage:  update [apt | fundle | git | raw | pip pip3 python python3 | snap | all]\n\tupdate all =:= update apt fundle git pip snap\n\tDefault:  update apt git pip snap'
    end
  end

  functions -e __update_apt
  functions -e __update_fundle
  functions -e __update_git
  functions -e __update_raw
  functions -e __update_pip
  functions -e __update_snap
end

#!/usr/bin/fish

function update -d 'automate software updates from installed SPMs'
  function __update_apt
        sudo apt-fast update;
    and sudo apt-fast autoremove -y;
    and sudo apt-fast upgrade -y;
    and sudo apt-fast install -fy;
    and sudo apt-fast clean -y
  end

  function __update_brew
    command brew update -v;
      and command brew cleanup
    builtin test -z (command brew outdated);
      and command brew upgrade -v;
      or  true
  end

  function __update_fundle
    sudo --user=root fish --command='builtin source /root/.config/fish/plugins.fish; and fundle self-update; and fundle clean; and for i in (fundle list --short | command shuf); fundle update $i; end'
  end

  function __update_git
    sudo updatedb
    for i in (sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
      builtin set --local current (command git -C $i rev-parse --short HEAD)
      builtin printf 'Updating %s ...\n' (command git -C $i config --get remote.origin.url);
        and sudo git -C (command dirname $i) pull --verbose
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

  function __update_snap
    for i in (sudo snap list | command sed -n '1!p' | command cut -d' ' -f1 | command shuf)
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
    and builtin set -l SPMs apt git raw snap;
    or  builtin set -l SPMs (builtin printf '%s\n' $argv | command sort -diu)
  for s in $SPMs
    switch $s
      case all
            __update_apt;
        and __update_brew;
        and __update_fundle;
        and __update_git;
        and __update_snap
      case apt
        __update_apt
      case brew
        __update_brew
      case fundle
        __update_fundle
      case git
        __update_git
      case snap
        __update_snap
      case '*'
        builtin printf '\a\tUsage:  update [apt | brew | fundle | git | snap | all]\n\tupdate all =:= update apt brew fundle git snap\n\tDefault:  update apt brew git snap'
    end
  end

  functions -e __update_apt
  functions -e __update_brew
  functions -e __update_fundle
  functions -e __update_git
  functions -e __update_raw
  functions -e __update_snap
end

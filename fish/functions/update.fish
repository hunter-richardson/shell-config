#!/bin/fish

function update -d 'automate software updates from installed SPMs'
  function __update_git
    for i in /home/RichardsonHR/git-repos/*
          command git -C $i config --get remote.origin.url;
      and command git -C $i pull
    end
  end
  function __update_pip
    for i in (command pip3 list --format=freeze | cut -d= -f1)
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2);
        command pip3 install $i -U -vvv
    end
  end

  builtin test (builtin count $argv) = 0;
    and builtin set -l SPMs git pip;
    or  builtin set -l SPMs (builtin printf '%s\n' $argv | command sort -diu)
  for s in $SPMs
    switch $s
      case all
            __update_git;
        and __update_pip
      case git
        __update_git
      case pip pip3 python python3
        __update_pip
      case '*'
        builtin printf '\a\tUsage:  update [git | pip pip3 python python3 | all]\n\tupdate all =:= update git pip\n\tDefault:  update git pip'
    end
  end
  functions -e __update_git
  functions -e __update_pip
end

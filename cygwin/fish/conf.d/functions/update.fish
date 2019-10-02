#!/bin/fish

function update -d 'automate software updates with git and fundle'
  function __update_git
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '--quiet';
      or  builtin set -l verbosity '--verbose';
    for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
      builtin set -l current (command git -C (command dirname $i) rev-parse --short HEAD);
        and builtin printf 'Updating %s/%s ...\n' (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f4,5 | builtin string replace / : | builtin string replace hunter-richardson \$ME);
        and builtin test $verbosity = '--verbose';
        and command git -C (command dirname $i) status --porcelain | builtin string trim -q;
        and builtin printf '%sLocal Changes:%s\n' $red $normal;
        and builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      command git -C (command dirname $i) pull $verbosity;
        and if builtin test $current != (command git -C (command dirname $i) rev-parse --short HEAD)
              if builtin string match -eq '/hunter-richardson/shell-config' (command dirname $i)
                builtin source ~/.config/fish/config.fish;
                  and command tmux source ~/tmux/conf
              else if builtin string match -eq '/tmux-plugins/tpm' (command dirname $i)
                command tmux source ~/tmux/conf
              end
            end
    end
  end

  function __update_fundle
    for i in (command find ~ -type f -name fundle.fish | command shuf)
      builtin source $i;
        and builtin printf 'load %s%sGITHUB/danhper:fundle fundle %s) $bold $blue $red $normal (command basename (command dirname $i))
    end;
      and for i in (command grep -Ev '^#' (command find ~ -type f -name fundle.plugins | command grep -v /git/) | command shuf)
            fundle plugin $i;
          end
      for i in (fundle install)
        builtin set -l iden (builtin printf '%s' $i | command cut -d' ' -f1);
          and builtin set -l src (builtin printf '%s\n' $__fundle_plugin_urls | command grep $iden | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
          and builtin set -l path (builtin printf '%s' $i | command awk '{print $NF}');
          and builtin printf '%s%s%s/%s%s%s => %s\n' $bold $blue $src $red (builtin string replace / : $iden | builtin string replace hunter-richardson \$ME) $normal $path
      end
      and fundle init;
      and fundle self-update;
      and fundle clean;
      and for i in (fundle list --short | command shuf)
            builtin set -l src (builtin printf '%s\n' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
              and for j in (fundle update $i)
                    builtin printf 'Updating %s%s%s/%s%s%s\n' $bold $blue $src $red (builtin string replace / : $i | builtin string replace hunter-richardson \$ME) $normal
                  end
            for f in (command ls -1 ~/.config/fish/fundle/$i/{comple,func}tions/*.fish | command shuf)
              builtin source $f;
                and builtin printf 'load %s%s%s/%s%s%s %s fish %s\n' $bold $blue $src $red (builtin string replace / : $i | builtin string replace hunter-richardson \$ME) $normal (command basename $f .fish) (command basename (command dirname $f) | builtin string replace s '')
            end;
          end;
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

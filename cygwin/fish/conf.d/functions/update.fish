#!/bin/fish

function update -d 'automate software updates with git and fundle'
  function __update_git
    builtin string match -iqr -- '--quiet' $argv;
      and builtin set -l verbosity '--quiet';
      or  builtin set -l verbosity '--verbose';
    for i in (command find ~ -type d -name .git | command grep -v /.config/ | command shuf)
      builtin set -l current (command git -C (command dirname $i) rev-parse --short HEAD);
        and builtin set -l src (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
        and builtin set -l iden (command basename (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f4,5 | builtin string replace / : | builtin string replace hunter-richardson \$ME) .git);
        and builtin printf 'Updating %s%s%s/%s%s%s ...\n' $bold $blue $src $red $iden $normal;
        and builtin test $verbosity = '--verbose';
        and command git -C (command dirname $i) status --porcelain | builtin string trim -q;
        and builtin printf '%sLocal Changes:%s\n' $red $normal;
        and builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      command git -C (command dirname $i) pull $verbosity;
        and if builtin test $current != (command git -C (command dirname $i) rev-parse --short HEAD)
              if builtin string match -eq '$ME:shell-config' $iden
                builtin source ~/.config/fish/config.fish;
                  and command tmux source ~/tmux/conf
              else if builtin string match -eq 'tmux-plugins:tpm' $iden
                command tmux source ~/tmux/conf
              end
            end
    end
  end

  function __update_fundle
    for i in functions completions
      builtin source ~/.config/fish/conf.d/$i/fundle.fish;
        and builtin string match -iqr -- '--quiet' $argv;
        or  builtin printf 'load %s%sGITHUB/%sdanhper:fundle%s fundle %s\n' $bold $blue $red $normal (builtin string replace s '' $i)
    end;
      and for i in (command grep -Ev '^#' (command find ~ -type f -name fundle.plugins | command grep -v /git/) | command shuf)
            fundle plugin $i;
              and if builtin test ! (builtin string match -iqr -- '--quiet' $argv)
                    builtin set -l src (builtin printf '%s' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
                      and builtin set -l iden (builtin string replace / : $i | builtin string replace hunter-richardson \$ME)
                    builtin printf 'load %s%s%s/%s%s%s,fundle plugin\n' $bold $blue $src $red $iden $normal
                  end
          end | command column -t -s, -o' '
    for i in (fundle install | command shuf)
      switch (builtin printf '%s' $i | command cut -d' ' -f1)
        case Installing
          builtin set -l iden (builtin printf '%s' $i | command awk '{print $NF}');
            and builtin set -l src (builtin printf '%s' $__fundle_plugin_urls | command grep $iden | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
            and builtin set -l path (builtin string join / (command find ~ -type d -name fundle) $iden);
            and builtin printf 'Installing plugin %s%s%s/%s%s%s,=> %s\n' $bold $blue $src $red (builtin string replace / : $iden | builtin string replace hunter-richardson \$ME) $normal $path
        case '*'
          builtin set -l iden (builtin printf '%s' $i | command cut -d' ' -f1);
            and builtin set -l src (builtin printf '%s\n' $__fundle_plugin_urls | command grep $iden | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
            and builtin set -l path (builtin printf '%s' $i | command awk '{print $NF}');
            and builtin printf 'plugin %s%s%s/%s%s%s,=> %s\n' $bold $blue $src $red (builtin string replace / : $iden | builtin string replace hunter-richardson \$ME) $normal $path
      end
    end | command column -t -s, -o' ';
      and fundle init;
      and fundle self-update | builtin string replace fundle (builtin printf '%s%sGITHUB/%sdanhper:fundle%s' $bold $blue $red $normal);
      and fundle clean
    for i in (fundle list --short | command shuf)
        builtin set -l src (builtin printf '%s\n' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
          and builtin set -l iden (builtin string replace / : $i | builtin string replace hunter-richardson \$ME)
        fundle update $i | builtin string replace $i (builtin printf 'plugin %s%s%s/%s%s%s ...' $bold $blue $src $red $iden $normal);
          and for f in (command ls -1 ~/.config/fish/fundle/$i/{comple,func}tions/*.fish | command shuf)
                builtin source $f;
                  and builtin string match -iqr -- '--quiet' $argv;
                  and true;
                  or  builtin printf 'load plugin %s%s%s/%s%s%s %s,%s\n' $bold $blue $src $red $iden $normal (command basename $f .fish) (command basename (command dirname $f) | builtin string replace s '')
              end | command column -t -s, -o' '
    end
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
        and eval __update_fundle $quiet
    else
      eval __update_git $quiet
      eval __update_fundle $quiet
    end
  else
    builtin printf 'Unable to open an Internet connection!\n';
      and builtin return 0
  end

  functions -e __update_{git,fundle}
end

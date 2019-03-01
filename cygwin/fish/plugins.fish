#!/usr/bin/fish

builtin set --local MY_DIR (command dirname (builtin status filename))

if builtin test -f $MY_DIR/conf.d/functions/fundle.fish
  builtin source $MY_DIR/conf.d/functions/fundle.fish
  builtin test -f $MY_DIR/conf.d/completions/fundle.fish;
    and builtin source $MY_DIR/conf.d/completions/fundle.fish
  for i in (builtin set -g | command cut -d' ' -f1 | command grep -E '^__fundle.*_plugin')
    set -e $i
  end

  for i in decors/fish-colored-man hunter-richardson/fish-bax hunter-richardson/fish-getopts hunter-richardson/fish-humanize-duration laughedelic/pisces oh-my-fish/plugin-await oh-my-fish/plugin-errno tuvistavie/fish-completion-helpers tuvistavie/oh-my-fish-core
    fundle plugin $i
  end
#  fundle plugin 'decors/fish-source-highlight'
#  fundle plugin 'oh-my-fish/plugin-xdg'
  fundle init

  builtin set --local new_fundle_plugin (builtin test ! -d (__fundle_plugins_dir))
  builtin test $new_fundle_plugin;
    or for i in (fundle list --short)
         builtin test $new_fundle_plugin;
           and builtin break;
           or  builtin set --local new_fundle_plugin (builtin test ! -d (__fundle_plugins_dir)/$i)
       end

  builtin test $new_fundle_plugin;
    and fundle install;
    and for i in (fundle list --short)
          builtin printf 'load plugin %s\n' $i | builtin string replace / :
          for f in functions completions
            builtin test -d $MY_DIR/fish/fundle/$i/$f;
              and command chmod a+x $MY_DIR/fish/fundle/$i/$f/*;
              and builtin source $MY_DIR/fish/fundle/$i/$f/*.fish
          end
        end;
    or  true
end

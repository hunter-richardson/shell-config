#!/usr/bin/fish

builtin set --local MY_DIR (command dirname (builtin status filename))

if builtin test -f $MY_DIR/conf.d/functions/fundle.fish
  builtin source $MY_DIR/conf.d/functions/fundle.fish
  fundle plugin 'edc/bass'
  fundle plugin 'decors/fish-colored-man'
  fundle plugin 'decors/fish-source-highlight'
  fundle plugin 'hunter-richardson/fish-humanize-duration'
  fundle plugin 'laughedelic/pisces'
  fundle plugin 'oh-my-fish/plugin-await'
  fundle plugin 'oh-my-fish/plugin-balias'
  fundle plugin 'oh-my-fish/plugin-errno'
#  fundle plugin 'oh-my-fish/plugin-xdg'
  fundle plugin 'tuvistavie/oh-my-fish-core'
  fundle init
end

builtin set --local new_fundle_plugin (builtin test ! -d $MY_DIR/fundle)
builtin test $new_fundle_plugin;
  or for i in (fundle list | command grep -v https://github.com)
       builtin test $new_fundle_plugin;
         and builtin break;
         or  builtin set --local new_fundle_plugin (builtin test ! -d $MY_DIR/fundle/$i)
     end

builtin test $new_fundle_plugin;
  and fundle install;
  and for i in (fundle list | command grep -v https://github.com)
        builtin printf 'load plugin %s\n' $i | builtin string replace / :
        for f in functions completions
          builtin test -d $MY_DIR/fish/fundle/$i/$f;
            and command chmod a+x $MY_DIR/fish/fundle/$i/$f/*;
            and builtin source $MY_DIR/fish/fundle/$i/$f/*.fish
        end
      end;
  or  true

#!/usr/bin/fish
# Put system-wide fish configuration entries here
# or in .fish files in conf.d/
# Files in conf.d can be overridden by the user
# by files with the same name in $XDG_CONFIG_HOME/fish/conf.d

# This file is run by all fish instances.
# To include configuration only for login shells, use
# if status --is-login
#    ...
# end
# To include configuration only for interactive shells, use
# if status --is-interactive
#   ...
# end

builtin set --local MY_DIR (command dirname (builtin status filename))

for i in functions completions
  builtin source $MY_DIR/conf.d/$i/fundle.fish;
    and builtin printf 'load GITHUB/danhper:fundle fundle %s\n' (builtin string replace s '' $i)
end

for i in (command grep -Ev '^#' (command find -type f -name fundle.plugins | command grep -v /git/) | command shuf);
  fundle plugin $i;
    and builtin printf 'load plugin %s/%s\n' (builtin printf '%s' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) (builtin string replace / : $i | builtin string replace hunter-richardson \$ME)
end

for i in (fundle list --short | command shuf)
  for d in functions completions
    builtin test -d $MY_DIR/fundle/$i/$d;
      and for f in (command ls -1 $MY_DIR/fundle/$i/$d/*.fish | command shuf)
            builtin source $f;
              and builtin printf 'source %s/%s %s %s\n' (builtin printf '%s' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) (builtin printf '%s' $i | builtin string replace / : | builtin string replace hunter-richardson \$ME) (command basename $f .fish) (builtin string replace s '' $d)
          end
  end
end

for i in functions completions
  for f in (command ls -1 $MY_DIR/conf.d/$i/*.fish | command grep -v 'fundle.fish$' | command shuf)
    builtin source $f;
      and builtin printf 'load GITHUB/$ME:shell-config %s %s\n' (command basename $f .fish) (builtin string replace s '' $i)
  end
end

for i in (command ls -1 $MY_DIR/conf.d/*.fish | command shuf)
  builtin source $i;
    and builtin printf 'load GITHUB/$ME:shell-config %s\n' (command basename $i .fish)
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin printf 'load GITHUB/$ME:shell-config alias\n';
  or  true

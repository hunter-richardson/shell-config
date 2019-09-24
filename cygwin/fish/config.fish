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

for i in (command grep -Ev '^#' (command find -type f -name fundle.plugins | command grep -v /git/) | command shuf);
  fundle plugin $i;
    and builtin printf 'load plugin %s/%s\n' (builtin printf '%s' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) (builtin string replace / : $i)
end

for i in (command ls -1 $MY_DIR/conf.d/**.fish)
  builtin source $i;
    and builtin printf 'source %s\n' $i
end

for i in (command ls -1 $MY_DIR/fundle/**/{comple,func}tions/*.fish)
  builtin source $i;
    and builtin printf 'source %s/%s %s %s\n' (builtin printf '%s' $__fundle_plugin_urls | command grep (builtin printf '%s' $i | command cut -d/ -f7,8) | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) (builtin printf '%s' $i | command cut -d/ -f7,8 | builtin string replace / :) (command basename $i .fish) (command basename (command dirname $i) | builtin string replace -r s '')
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin printf 'source %s/alias.fish\n' $MY_DIR;
  or  true

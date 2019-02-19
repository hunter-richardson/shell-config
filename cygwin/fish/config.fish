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

builtin test -f $MY_DIR/plugins.fish;
  and builtin source $MY_DIR/plugins.fish;
  and builtin printf 'source %s/plugins.fish\n' $MY_DIR;
  or  true

for i in conf.d/functions conf.d conf.d/completions
  builtin test (builtin count $MY_DIR/$i/*.fish);
    and for f in $MY_DIR/$i/*.fish
          builtin source $f;
            and builtin printf 'source %s\n' $f
        end
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin printf 'source %s/alias.fish\n' $MY_DIR;
  or  true

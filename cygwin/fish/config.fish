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

set --local MY_DIR (command dirname (builtin status filename))

fundle plugin 'edc/bass'
fundle plugin 'decors/fish-colored-man'
fundle plugin 'decors/fish-source-highlight'
fundle plugin 'laughedelic/pisces'
fundle plugin 'oh-my-fish/plugin-await'
fundle plugin 'oh-my-fish/plugin-balias'
fundle plugin 'oh-my-fish/plugin-errno'
#fundle plugin 'oh-my-fish/plugin-xdg'
fundle plugin 'tuvistavie/oh-my-fish-core'
fundle init

if builtin test ! -d $MY_DIR/fundle
  fundle install
  for i in (fundle list | command grep -v https://github.com)
    builtin test -d $MY_DIR/fundle/$i/completions;
      and chmod a+x $MY_DIR/fish/fundle/$i/completions/*
    builtin test -d $MY_DIR/fundle/$i/functions;
      and chmod a+x $MY_DIR/fish/fundle/$i/functions/*
  end
end

builtin test -f $MY_DIR/conf.d/functions.fish;
  and source $MY_DIR/conf.d/functions.fish;
  or  true


builtin test (builtin count $MY_DIR/conf.d/*.fish);
  and for i in $MY_DIR/conf.d/*.fish
        source $i
      end;
  or  true

builtin test (builtin count $MY_DIR/conf.d/completions/*.fish);
  and for i in $MY_DIR/conf.d/completions/*.fish
        source $i
      end;
  or  true

builtin test -f $MY_DIR/alias.fish;
  and source $MY_DIR/alias.fish;
  or  true

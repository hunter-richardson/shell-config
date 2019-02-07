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

set --local MY_DIR (realname (command dirname (builtin status filename))/..)
source $MY_DIR/conf.d/aliases.fish
source $MY_DIR/conf.d/functions/include.fish

include \
  $MY_DIR/conf.d/*.fish \
  $MY_DIR/conf.d/completions/*.fish


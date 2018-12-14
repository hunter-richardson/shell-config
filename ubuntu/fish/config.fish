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


source /etc/fish/conf.d/functions/include.fish

include \
  /etc/fish/export_vars.fish \
  /etc/fish/a*s.fish \
  /etc/fish/conf.d/completions/*.fish \
  /etc/fish/conf.d/functions/*.fish \
  /etc/fish/conf.d/functions/fundle/*.fish

builtin test -e "~/Downloads/*";
  and command srm -lrvz ~/Downloads/*
#  or  true
builtin test -e "~/tmux-*.log"
  and command scp -v ~/tmux-*.log /var/log/tmux/(whoami)/
  and command srm -lrvz ~/tmux-*.log
#  or  true

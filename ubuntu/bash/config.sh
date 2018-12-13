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


source /etc/fish/functions/include.fish

include \
  /etc/fish/functions/*.fish \
  /etc/fish/export_vars.sh \
  /etc/fish/aliases.sh

if [ -e "~/Downloads/*" ]
then
  command srm -lrvz ~/Downloads/*
fi
if [ -e "~/tmux-*.log" ]
then
  command scp -v ~/tmux-*.log /var/log/tmux/$(whoami)/
  command srm -lrvz ~/tmux-*.log
fi

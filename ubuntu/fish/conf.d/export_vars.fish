#!/usr/bin/fish
# Put system-wide fish environmental variables here
# or in .fish files in conf.d/
# Files in conf.d can be overridden by the user
# by files with the same name in $XDG_CONFIG_HOME/fish/conf.d

# This file is run by all fish instances.
# end

builtin set -e fish_bind_mode
builtin set -e fish_greeting
builtin set -g backred (builtin set_color -b red)
builtin set -g backmagenta (builtin set_color -b magenta)
builtin set -g backgreen (builtin set_color -b green)
builtin set -g backwhite (builtin set_color -b white)
builtin set -g backblue (builtin set_color -b blue)
builtin set -g backcyan (builtin set_color -b cyan)
builtin set -g backyellow (builtin set_color -b yellow)
builtin set -g red (builtin set_color brred)
builtin set -g magenta (builtin set_color brmagenta)
builtin set -g green (builtin set_color brgreen)
builtin set -g white (builtin set_color brwhite)
builtin set -g blue (builtin set_color brblue)
builtin set -g cyan (builtin set_color brcyan)
builtin set -g yellow (builtin set_color bryellow)
builtin set -g bold (builtin set_color -o)
builtin set -g nobold (builtin set_color -d)
builtin set -g underline (builtin set_color -u)
builtin set -g italic (builtin set_color -i)
builtin set -g rcolors (builtin set_color -r)
builtin set -g normal (builtin set_color normal)
builtin set -g EDITOR /bin/nano
builtin set -g BROWSER /usr/bin/w3m
builtin set -g SHELL /usr/bin/fish
builtin set -g LANG en_US.utf8
builtin set -g PYTHONIOENCODING 'utf-8'
builtin set -g LESS ' -R '
builtin set -g bookmarks ''
builtin set -g nocmdhist commands directories bookmarks cat less ll ls
builtin set -g grc_plugin_execs cat cvs df diff dig gcc g++ ifconfig make mount mtr netstat ping ps tail traceroute wdiff
builtin set -g LANG en_US.UTF-8
builtin set -g LC_CTYPE en_US.UTF-8
builtin set -g BAT_CONFIG_DIR /etc/bat/conf



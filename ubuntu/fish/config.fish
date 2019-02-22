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

for i in functions/count_files.fish export_vars.fish
  builtin test -f $MY_DIR/conf.d/$i;
    and builtin source $MY_DIR/conf.d/$i;
    and builtin printf 'source %s/conf.d/%s\n' $MY_DIR $i
end

for i in conf.d/functions conf.d conf.d/completions
  builtin test (builtin count (command ls $MY_DIR/$i/*.fish))
    and for f in $MY_DIR/$i/*.fish
          builtin source $f;
            and builtin printf 'source %s\n' $f
        end
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin printf 'source %s/alias.fish\n' $MY_DIR;
  or  true

builtin test (builtin command -v pip3) -a (builtin command pip3 show thefuck) -a (builtin functions -q thefuck-command-line);
  and builtin bind \e\e 'thefuck-command-line';
  and builtin printf 'bind ESC-ESC thefuck';
  or  true

#builtin test (builtin count (command ls {$HOME}/Downloads/*));
#  and command srm -lrvz {$HOME}/Downloads/*
#  or  true

builtin test ! (command -v brew) -a -d /home/linuxbrew;
  and builtin eval (/home/linuxbrew/bin/brew shellenv);
  and builtin printf 'eval linuxbrew shellenv'

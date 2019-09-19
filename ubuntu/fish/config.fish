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
    and builtin test (command whoami) != root
    and builtin printf 'source %s/conf.d/%s\n' $MY_DIR $i;
    or  true
end

for i in (command ls -1 $MY_DIR/conf.d/**.fish)
  builtin source $f;
    and builtin test (command whoami) != root
    and builtin printf 'source %s\n' $f;
    or  true
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin test (command whoami) != root
  and builtin printf 'source %s/alias.fish\n' $MY_DIR;
  or  true

builtin command -v albert >/dev/null;
  and builtin bind \e\e 'command albert show 1>/dev/null 2>/dev/null';
  and builtin test (command whoami) != root
  and builtin printf 'bind ESC-ESC albert\n';
  or  true

builtin command -v brew >/dev/null;
  and builtin functions -q bax;
  command brew shellenv


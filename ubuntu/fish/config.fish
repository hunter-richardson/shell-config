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

builtin source /root/.config/fish/conf.d/functions/fundle.fish;
  and for i in (command grep -Ev '^#' /root/.config/fish/fundle.plugins | command shuf)
        fundle plugin $i;
          and builtin printf 'load plugin %s/%s by fundle\n' (builtin printf '%s' $__fundle_plugin_urls | builtin string match $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) (builtin string replace / : $i | builtin string replace hunter-richardson \$ME)
      end;
  and fundle init;
  and functions -e fundle

for i in functions completions
  builtin test -d $MY_DIR/conf.d/$i;
    and for f in (command ls -1 $MY_DIR/conf.d/$i/*.fish | command shuf)
          builtin source $f;
            and builtin test (command whoami) != root;
            and builtin printf 'load %s\n' (
              contains_seq (command basename $i .fish) fish_prompt fish_right_prompt fuck gclone learn open refish speak update youtube-dl;
                and builtin printf 'GITHUB/$ME:shell-config %s %s' (command basename $f .fish) (builtin string replace s '' $i);
                or  builtin printf '%s %s from fundle plugin' (builtin string replace s '' $i) (command basename $f .fish));
            or  true
        end
end

for f in (command ls -1 $MY_DIR/conf.d/*.fish | command shuf)
  builtin source $f;
    and builtin test (command whoami) != root;
    and builtin printf 'source %s\n' $f;
    or  true
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin test (command whoami) != root;
  and builtin printf 'source %s/alias.fish\n' $MY_DIR;
  or  true

builtin command -v albert >/dev/null;
  and builtin bind \e\e 'command albert show 1>/dev/null 2>/dev/null';
  and builtin test (command whoami) != root;
  and builtin printf 'bind ESC-ESC albert\n';
  or  true

builtin command -v brew >/dev/null;
  and builtin functions -q bax;
  command brew shellenv


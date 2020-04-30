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

builtin test -d $MY_DIR/conf.d/init;
  and builtin test (builtin count $MY_DIR/conf.d/init/*.fish) -ge 1;
  and for i in (command ls -1 $MY_DIR/conf.d/init/*.fish)
        builtin source $i;
          and builtin test (command whoami) != root;
          and builtin printf 'initialize %s%s%s%s,plugin\n' $bold $red (command basename $i .fish) $normal
      end | command column -t -s,

builtin set -l MY_FILES (command ls -1 (command locate -ieq 'shell-config' | command head -1)/{agnostic,ubuntu}/fish/conf.d/*/*.fish | command xargs -n 1 basename);
  and for i in functions completions
        builtin test -d $MY_DIR/conf.d/$i;
          and for f in (command ls -1 $MY_DIR/conf.d/$i/*.fish | command shuf)
                builtin source $f;
                  and builtin test (command whoami) != root;
                  and builtin printf 'load %s\n' (
                    builtin contains (command basename $f) $MY_FILES;
                      and builtin printf '%s%sGITHUB/%s$ME:shell-config%s %s,%s%s%s' $bold $blue $red $normal (command basename $f .fish) $yellow (builtin string replace s '' $i) $normal;
                      or  builtin printf 'plugin %s,%s%s%s' (command basename $f .fish) $yellow (builtin string replace s '' $i) $normal);
                  or  true
              end | command column -t -s,
      end

for f in (command ls -1 $MY_DIR/conf.d/*.fish | command shuf)
  builtin source $f;
    and builtin test (command whoami) != root;
    and builtin printf 'load %s%sGITHUB/%s$ME:shell-config%s %s\n' $bold $blue $red $normal (
      builtin test (command basename $f .fish) = abbrs;
        and builtin printf 'abbreviations';
        or  builtin printf 'exported variables');
    or  true
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin test (command whoami) != root;
  and builtin printf 'load %s%sGITHUB/%s$ME:shell-config%s aliases\n' $bold $blue $red $normal;
  or  true

builtin test (command whoami) != root;
  and builtin command -v albert >/dev/null;
  and builtin bind \e\e 'command albert show 1>/dev/null 2>/dev/null';
  and builtin printf 'bind ESC-ESC albert\n';
  or  true

builtin test (command whoami) != root;
  and builtin command -v /home/linuxbrew/.linuxbrew/bin/brew shellenv;
  and builtin functions -q bax


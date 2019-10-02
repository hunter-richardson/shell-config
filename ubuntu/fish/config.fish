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

for i in functions completions
  builtin test -d $MY_DIR/conf.d/$i;
    and builtin set -l MY_FILES (command ls -1 (command find / -type d -name shell-config)/{agnostic,ubuntu}/fish/conf.d/$i/*.fish | command xargs -n 1 basename);
    and for f in (command ls -1 $MY_DIR/conf.d/$i/*.fish | command shuf)
          builtin source $f;
            and builtin test (command whoami) != root;
            and builtin printf 'load %s\n' (
              builtin contains (command basename $f) $MY_FILES;
                and builtin printf '%s%sGITHUB/%s$ME:shell-config%s %s,%s' $bold $blue $red $normal (command basename $f .fish) (builtin string replace s '' $i);
                or  builtin printf 'fundle plugin %s,%s' (builtin string replace s '' $i) (command basename $f .fish));
            or  true
        end | command column -t -s, -o' '
end

for i in (command ls -1 $MY_DIR/conf.d/init/*.fish)
  builtin source $i;
    and builtin test (command whoami) != root;
    and builtin printf 'initialize plugin %s' (command basename (command dirname $i))
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
  and builtin command -v brew >/dev/null;
  and builtin functions -q bax;
  and command brew shellenv;
  and builtin command -v albert >/dev/null;
  and builtin bind \e\e 'command albert show 1>/dev/null 2>/dev/null';
  and builtin printf 'bind ESC-ESC albert\n'


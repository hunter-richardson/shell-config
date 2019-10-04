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

builtin set --local MY_DIR (command dirname (builtin status filename))

for i in functions completions
  builtin source $MY_DIR/conf.d/$i/fundle.fish;
    and builtin printf 'load %s%sGITHUB/%sdanhper:fundle%s fundle %s%s%s\n' $bold $blue $red $normal $yellow (builtin string replace s '' $i) $normal
end

for i in (command grep -Ev '^#' (command find -type f -name fundle.plugins | command grep -v /git/) | command shuf);
  fundle plugin $i;
    and builtin set -l src (builtin printf '%s' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
    and builtin printf 'load %s%s%s/%s%s%s,fundle plugin\n' $bold $blue $src $red (builtin string replace / : $i | builtin string replace hunter-richardson \$ME) $normal
end | command column -t -s, -o' ';
  and fundle init

for i in (fundle list --short | command shuf)
  builtin set -l src (builtin printf '%s' $__fundle_plugin_urls | command grep $i | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
    and builtin set -l iden (builtin string replace / : $i | builtin string replace hunter-richardson \$ME);
  for d in functions completions
    builtin test -d $MY_DIR/fundle/$i/$d;
      and for f in (command ls -1 $MY_DIR/fundle/$i/$d/*.fish | command shuf)
            builtin source $f;
              and builtin printf 'load plugin %s%s%s/%s%s%s,%s,%s%s%s\n' $bold $blue $src $red $iden $normal (command basename $f .fish) $yellow (builtin string replace s '' $d) $normal
          end
  end | command column -t -s, -o' '
end

for i in functions completions
  for f in (command ls -1 $MY_DIR/conf.d/$i/*.fish | builtin string match -vr 'fundle.fish$' | command shuf)
    builtin source $f;
      and builtin printf 'load %s%sGITHUB/%s$ME:shell-config%s %s,%s%s%s\n' $bold $blue $red $normal (command basename $f .fish) $yellow (builtin string replace s '' $i) $normal
  end | command column -t -s, -o' '
end

for i in (command ls -1 $MY_DIR/conf.d/*.fish | command shuf)
  builtin source $i;
    and builtin printf 'load %s%sGITHUB/%s$ME:shell-config%s %s\n' $bold $blue $red $normal (
      builtin string match -iqr 'abbrs' (command basename $i .fish);
        and builtin printf 'abbreviations';
        or  builtin printf 'exported variables')
end

builtin test -f $MY_DIR/alias.fish;
  and builtin source $MY_DIR/alias.fish;
  and builtin printf 'load %s%sGITHUB/%s$ME:shell-config%s aliases\n' $bold $blue $red $normal;
  or  true

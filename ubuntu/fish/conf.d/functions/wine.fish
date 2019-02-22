#!/usr/bin/fish

function wine -d 'use multiuser wine installation'
  builtin test ! (builtin set -q $argv);
    and builitn printf 'No arguments given!';
    and builtin return 1
  if builtin test ! (builtin command -v wine)
    builtin printf 'wine not installed!';
      and builtin return 1
  else if builtin contains (command members wine-user) (command whoami)
    for i in $argv
      builtin set -l matched (builtin string match -r '^https?://' $i)
      builtin set -l param (builtin test $match;
                              and builtin printf '/dev/stdout';
                              or  builtin printf '%s' $i)
      sudo --user=wine --command=(builtin printf '%scommand wine start %s &; and builtin disown' (builtin test $matched;
                                                                                                    and builtin printf 'command wget %s | ' $i;
                                                                                                    or  builtin printf '') $param)
      builtin set -e matched param
    end
  else
    builtin printf "You aren't a wine drinker...";
      and builtin return 1
  end
end


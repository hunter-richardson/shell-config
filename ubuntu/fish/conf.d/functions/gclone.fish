#!/usr/bin/fish

function gclone -d 'default git options'
  builtin test ! (command members sudo | command grep (command whoami)) -a ! (command members root | command grep (command whoami));
    and echo 'You are not a sudoer!'
    and return 121
  for i in $argv
    builtin set -l repo (builtin string split -r -m1 '/' $i | command cut -d' ' -f1)[-1];
      and builtin test -z $repo;
        and command sudo git clone --verbose --depth 1 $i ./$repo
  end
end

#!/bin/fish

function mv -d 'securely move source to destination'
  if builtin test (builtin count $argv) -ne 2 -o builtin string match -r '[\?\*]' $argv;
    builtin printf '%s%sImproper usage%s:\t%s ' $bold $red $normal (command basename (builtin status filename) | builtin string split .)[1]
    builtin string trim (builtin printf ' %s' $argv);
    builtin printf '.\n%s%sUsage%s:  %s [source-location] [destination-location]' $bold $red $normal (command basename (builtin status filename) | builtin string split .)[1]
    builtin string match -r '[?\*]' $argv;
      and builtin printf '%s%sNote%:  Wildcards [*?] not implemented.'
    builtin return 1
  end
  builtin test ! -e $argv[1] -o ! -r $argv[1] -o ! -w $argv[1];
    and builtin printf 'Source file %s%s%s%s %s' $bold $red $argv[1] $normal (
      if builtin test ! -e $argv[1]
        builtin printf 'does not exist.'
      else if builtin test -r $argv[2]
        builtin printf 'is readonly.'
      else
        builtin printf 'is unreadable.'
      end);
    and builtin return 1
  builtin test -e $argv[2] -a \( ! -r $argv[2] -o ! -w $argv[2] \)
    and builtin printf 'Destination file %s%s%s%s exists but is %s.' $bold $red $argv[2] $normal (
      builtin test -r $argv[2];
        and builtin printf 'readonly';
        or  builtin printf 'unreadable');
    and builtin return 1
  command scp -v $argv[1] $argv[2];
    and rm $argv[1]
end

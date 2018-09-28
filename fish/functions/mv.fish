#!/bin/fish

function mv
  if builtin test -z "$1" -o -z "$2"
    builtin printf 'Improper usage.\n%s%sUsage%s:  mv [source-location] [destination-location]' $bold $red $normal
  else if builtin test ! -e "$1"
    builtin printf 'Source file %s%s%s%s does not exist.' $bold $red $1 $normal
  else if builtin test ! -r "$1"
    builtin printf 'Source file %s%s%s%s is unreadable.' $bold $red $1 $normal
  else if builtin test ! -w "$1"
    builtin printf 'Source file %s%s%s%s is readonly.' $bold $red $1 $normal
  else if builtin test -e "$2" -a ! -r "$2"
    builtin printf 'Destination file %s%s%s%s exists but is unreadable.' $bold $red $2 $normal
  else if builtin test -e "$2" -a ! -w "$2"
    builtin printf 'Destination file %s%s%s%s exists but is readonly.' $bold $red $2 $normal
  else
    command scp -v $1 $2
    rm $1
  end
end

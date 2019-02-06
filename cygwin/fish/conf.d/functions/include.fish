#!/bin/fish

function include -d 'source files to fish, if they are readable, error otherwise'
  builtin argparse 'q' -- $argv
  builtin set -l retval 0
  for i in $argv
    if builtin test ! -e $i
      builtin set -q $flag_q;
        or builtin printf 'File %s%s%s%s does not exist.\n' $bold $red $i $normal
      builtin set retval 1
    else if builtin test ! -s $i
      builtin set -q $flag_q;
        or builtin printf '%s%s%s%s is an empty file.\n' $bold $red $i $normal
      builtin set retval 1
    else if builtin test ! -f $i
      builtin set -q $flag_q;
        or builtin printf '%s%s%s%s is not a source file.\n' $bold $red $i $normal
      builtin set retval 1
    else if builtin test ! -r $i
      builtin set -q $flag_q;
        or builtin printf 'File %s%s%s%s is unreadable.\n' $bold $red $i $normal
      builtin set retval 1
    else
      builtin source $i
      if builtin test $status -eq 0
        builtin set -q $flag_q;
          or builtin printf 'File %s%s%s%s loaded.\n' $bold $green $i $normal
      else
        builtin set -q $flag_q;
          or builtin printf 'File %s%s%s%s failed to load.\n' $bold $red $i $normal
        builtin set retval 1
      end
    end
  end
  builtin return $retval
end


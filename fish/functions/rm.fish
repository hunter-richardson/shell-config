#!/bin/fish

function rm --description 'securely erase and remove files or directories'
  builtin test (builtin count $argv) -eq 0
    and builtin return 0
  builtin set -l retval 0
  for i in $argv
    if builtin test ! -e $1
      builtin printf '%s%s%s%s:  no such file or directory exists.\n' $bold $red $i $normal
      set retval 1
    else if builtin test -d $i -a -w $i
      eval $_ $i/*
      and command rm -dv $i
    else if builtin test -f $i -a -w $i
      builtin test -s $i
        and command shred -fvxz --remove=unlink --iterations=1 $i
        or command rm -fv $i
    else
      builtin printf 'Cannot delete file %s%s%s%s!\n' $bold $red $i $normal
      builtin set retval 2
    end
  end
  builtin return $retval
end

#!/bin/fish

function rm --description 'securely erase and remove files or directories'
  builtin test (builtin count $argv) -eq 0
    and builtin return 0
  builtin set -l retval 0
  for i in $argv
    if builtin test ! -e $i
      builtin printf '%s%s%s%s:  no such file or directory exists.\n' $bold $red $i $normal
      set retval 1
    else if builtin test \( ! -w (command dirname $i) -o -k $i \) -a \( (command stat -printf='%U' $i) = (command whoami) -o (command whoami) = "root" \)
      chmod a-t,u+w $i;
        and eval $_ $i
    else if builtin test -w $i
      if builtin test -d $i
        builtin test (command ls -1A $i | wc -l) -gt 0;
          and eval $_ $i/(command ls -1A $i)
        builtin test $retval -eq 0;
          and command rm -dv $i
      else if builtin test -f $i
        builtin test -s $i;
          and command shred -fuvxz --remove=unlink --iterations=1 $i
          or  command rm -fv $i;
      end
    else
      builtin printf 'Cannot delete file %s%s%s%s!\n' $bold $red $i $normal
      builtin set retval 2
    end
  end
  builtin return $retval
end

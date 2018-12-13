#!/bin/fish

function open
  builtin test -n $argv[1]; and builtin set -l err " ... the door is either locked or gone!"; or builtin echo "Open what?"; and builtin return 1
  builtin set -l type (builtin test -e $argv[1]; and command ls -l $argv[1] | command sed '2p' | command cut -d' ' -f1 | command cut -d'r' -f1); or echo '0'
  builtin test -e $argv[1] -a ! -r $argv[1]; and builtin printf '%s%s%s%s:  %s' $bold $red $argv $normal $err; and builtin return 1
  builtin test -n (command which $argv[1]); and command man $argv[1]; and builtin return 0
  type $argv[1] ^/dev/null; and builtin return 0;
  switch $type;
      case b
        builtin set -l mnt (command mount | command grep $argv[1] | command cut -d' ' -f3 | head -1)
        builtin test -n $mnt -a -r $mnt; and eval $_ $argv[1]; or begin; builtin printf '%s%s%s%s:  %s' $bold $red $argv[1] $normal $err; and builtin return 1; end;
      case c s
        command cat $argv[1]
      case d
        /cygdrive/c/windows/explorer.exe $argv[1]
      case l
        builtin set -l lnk (command readlink -f $argv[1])
        builtin test -n $lnk -a -r $lnk; and eval $_ $lnk; or begin; builtin printf '%s%s%s%s%s:  %s' $red $bold $argv[1] $normal $err; and builtin return 1; end;
      case p
        command cat < $argv[1]
      case -
        command open $argv[1]
  end
end

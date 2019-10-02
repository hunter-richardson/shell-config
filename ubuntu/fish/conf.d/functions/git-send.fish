#!/usr/bin/fish

function git-send -d 'Adds, commits, and pushes all changes in the git repository'
  if builtin test -z "$argv[2]"
    eval (builtin status current-function) $argv[1] (command pwd)
  else if builtin test -d $argv[2] -a (command git -C $argv[2] rev-parse --is-inside-work=tree ^/dev/null);
    builtin set -l perms (    builtin test -w $2;
                          and builtin test -x $2);
      and builtin set -l url (command git -C $argv[2] config --get remote.origin.url);
      and builtin printf '%sREPOSITORY: %s/%s\n' (builtin test $perms;
                                                    and builtin printf 'GLOBAL ';
                                                    or  builtin printf '') \
                                                 (builtin printf '%s' $url | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) \
                                                 (builtin printf '%s' $url | command cut -d/ -f4,5 | builtin string replace / : | builtin string replace hunter-richardson \$ME)
    command git -C $argv[2] status --porcelain | builtin string length -q;
      and builtin printf '%sLocal Changes:%s\n' $red $normal;
      and builtin printf '\t%s\n' (command git -C $argv[2] status --porcelain);
      and builtin printf '\n'
    builtin test $perms;
      and command git -C $argv[2] pull --verbose;
      or     sudo git -C $argv[2] pull --verbose;
    command git -C $argv[2] diff --check | builtin string length -q;
      and builtin printf '\n%s%sPlease resolve merge conflicts!%s\n' $red $bold $normal;
      and builtin return 1;
    if command git -C $argv[2] diff | builtin string length -q
      builtin test $perms;
        and command git -C $argv[2] add --all --renormalize
        or     sudo git -C $argv[2] add --all --renormalize;
      command git -C $argv[2] diff --cached | builtin string length -q;
        and builtin printf '\n%sStaged Changes:%s\n' $red $normal;
        and builtin printf '\t%s\n' (command git -C $argv[2] diff --cached);
        and builtin printf '\n'
    end
    if builtin test -z "$argv[1]"
      builtin test $perms;
        and command git -C $argv[2] commit --allow-empty-message --verbose
        or     sudo git -C $argv[2] commit --allow-empty-message --verbose
    else
      builtin test $perms;
        and command git -C $argv[2] commit --verbose --message="$argv[1]"
        or     sudo git -C $argv[2] commit --verbose --message="$argv[1]"
    end;
      and builtin test $perms;
            and command git -C $argv[2] push --verbose;
            or     sudo git -C $argv[2] push --verbose
  else
    builtin printf 'fatal: not a git repository: %s' $argv[2]
  end
end

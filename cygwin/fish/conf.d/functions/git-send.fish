#!/usr/bin/fish

function git-send -d 'Adds, commits, and pushes all changes in the git repository'
  if builtin test -z "$argv[2]"
    eval (builtin status current-function) $argv[1] (command pwd)
  else if \( builtin test ! -w $argv[2];
          or builtin test ! -x $argv[2] \)
    builtin printf 'fatal: %s has insufficient permissions to modify the local repository at %s' (command whoami) $argv[2];
      and builtin return 1
  else if builtin test -d $argv[2] -a (command git -C $argv[2] rev-parse --is-inside-work=tree ^/dev/null);
    builtin set -l url (command git -C $argv[2] config --get remote.origin.url);
      and builtin printf 'REPOSITORY: %s/%s\n' (builtin printf '%s' $url | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper) \
                                               (builtin printf '%s' $url | command cut -d/ -f4,5 | builtin string replace / : | builtin string replace hunter-richardson \$ME)
    command git -C $argv[2] status --porcelain | builtin string length -q;
      and builtin printf '%sLocal Changes:%s\n' $red $normal;
      and builtin printf '\t%s\n' (command git -C $argv[2] status --porcelain);
      and builtin printf '\n'
    command git -C $argv[2] pull --verbose;
      and command git -C $argv[2] diff --check | builtin string length -q;
      and builtin printf '\n%s%sPlease resolve merge conflicts!%s\n' $red $bold $normal;
      and builtin return 1;
    command git -C $argv[2] diff | builtin string length -q;
      and command git -C $argv[2] add --all --renormalize;
      and command git -C $argv[2] diff --cached | builtin string length -q;
      and builtin printf '\n%sStaged Changes:%s\n' $red $normal;
      and command git -C $argv[2] diff --cached;
      and builtin printf '\n';
    if builtin test -z "$argv[1]"
      command git -C $argv[2] commit --allow-empty-message --verbose
    else
      command git -C $argv[2] commit --verbose --message="$argv[1]"
    end;
      and command git -C $argv[2] push --verbose
  else
    builtin printf 'fatal: not a git repository: %s' $argv[2];
      builtin return 1
  end
end

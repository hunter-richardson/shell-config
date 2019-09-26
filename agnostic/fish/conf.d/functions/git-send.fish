#!/usr/bin/fish

function git-send -d 'Adds, commits, and pushes all changes in the git repository'
  if builtin test -z "$argv[2]"
    eval (builtin status current-function) $argv[1] (command pwd)
  else if builtin test -d $argv[2] -a (command git -C $argv[2] rev-parse --is-inside-work=tree ^/dev/null);
    command git -C $argv[2] status --porcelain | builtin string length -q;
      and builtin printf '%sLocal Changes:%s\n' $red $normal;
      and builtin printf '\t%s\n' (command git -C $argv[2] status --porcelain)
    command git -C $argv[2] pull --verbose;
      and command git -C $argv[2] diff --check | builtin string length -q;
      and builtin printf '%s%sPlease resolve merge conflicts!%s\n' $red $bold $normal;
      and builtin return 1;
    command git -C $argv[2] diff | builtin string length -q;
      and command git -C $argv[2] add --all --renormalize;
      and command git -C $argv[2] diff --cached | builtin string length -q;
      and builtin printf '%sStaged changes:%s\n' $red $normal;
      and builtin printf '\t%s\n' (command git -C $argv[2] diff --cached);
    if builtin test -z "$argv[1]"
      command git -C $argv[2] commit --allow-empty-message --verbose
    else
      command git -C $argv[2] commit --verbose --message="$argv[1]"
    end;
      and command git -C $argv[2] push --verbose
  else
    builtin printf 'fatal: not a git repository: %s' $argv[2]
  end
end

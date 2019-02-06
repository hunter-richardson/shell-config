function dtrx --description 'alias to GITHUB/moonpyk:dtrx'
  builtin test -z "$argv";
    and builtin printf 'No arguments given!';
    and return 1;
  builtin set repo (builtin status filename)
  builtin test -z "$repo";
    and builtin printf 'An error occured while attempting to determine the script directory.\n';
    and builtin set -e perms uname repo conf;
    and builtin return 1
  while builtin test -f $repo -o -L $repo;
    builtin set repo (builtin test -L $repo;
                        and return (command readlink $repo))
                        or  return (command dirname $repo);
  end
  builtin test ! -f (command dirname $repo)/dtrx/scripts/dtrx;
    and builtin printf '%s not installed!' https://github.com/moonpyk/dtrx;
    and return 0;
    or  (command dirname $repo)/dtrx/scripts/dtrx -forv --one-entry=inside $argv
  set -e repo
end

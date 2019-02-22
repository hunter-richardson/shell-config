#!/usr/bin/fish

function count_files -d "count the files in a directory, or name the file if there's only one"
  builtin test -n $argv[1] -a -e $argv[1] -a -x $argv[1];
    or builtin return 2
  builtin test ! -d $argv[1];
    and builtin printf '%d' (builtin count $argv[1]);
    and builtin return 0
  builtin set -l file_count (builtin count (command ls -R --indicator-style=file-type $argv[1] | command grep -v / | builtin string match -v --regex '^$'))
  builtin set -l file (command ls -R --indicator-style=file-type $argv[1] | command grep -v / | builtin string match -v --regex '^$')[1]
  switch $file_count
    case 0
      builtin printf ''
    case 1
      builtin printf '%s' $file
    case '*'
      builtin printf '%u' $file_count
  end
end

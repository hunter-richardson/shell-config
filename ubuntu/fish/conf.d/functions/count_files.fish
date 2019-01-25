#!/usr/bin/fish

function count_files -d "count the files in a directory, or name the file if there's only one"
  if builtin test -z $argv[1] -o ! -e $argv[1] -o ! -x $argv[1]
    return 2
  else if builtin test ! -d $argv[1];
    builtin printf '%d' (builtin count $argv[1])
    return 0
  end
  set -l file_count (builtin count (command ls -R --indicator-style=file-type $argv[1] | command grep -v / | builtin string match -v --regex '^$'))
  set -l file (command ls -R --indicator-style=file-type $argv[1] | command grep -v / | builtin string match -v --regex '^$')[1]
  switch $file_count
    case 0
      builtin printf ''
    case 1
      builtin printf '%s' $file
    case '*'
      builtin printf '%u' $file_count
  end
end

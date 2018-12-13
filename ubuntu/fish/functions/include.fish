#!/usr/bin/fish

function include -d 'source files to fish, if they are readable, error otherwise'
  for i in $argv
    test -r $i; and source $i
  end
end

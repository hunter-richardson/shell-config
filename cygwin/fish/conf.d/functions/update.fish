#!/bin/fish

function update -d 'automate software updates git repos'
  for i in (command find ~ -type d -name .git)
    command git -C (command dirname $i) pull --verbose
  end
end

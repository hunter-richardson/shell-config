#!/bin/fish

function update -d 'automate software updates git repos'
  for i in (command find ~ -type d -name .git)
        command git -C (command dirname $i) config --get remote.origin.url;
    and command git -C (command dirname $i) pull
  end
end

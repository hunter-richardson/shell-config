#!/usr/bin/fish

function speak
  if builtin command -v spd-say
    builtin test (builtin command -v fortune) -a (builtin set -q $argv);
      and command spd-say $argv;
      or  command spd-say (command fortune)
  end
end

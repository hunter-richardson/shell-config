#!/bin/fish

function fish_right_prompt -d 'the right prompt'
  builtin set -l cmd_performance $CMD_DURATION
  builtin test $cmd_performance -gt 0;
    and builtin printf '%s%s  %u ms' $bold $blue $cmd_performance
  builtin printf ' %s%s%s %s' $bold $cyan (command whoami)
  builtin printf ' %s%s%s%s' $bold $magenta (
    if builtin test (command git rev-parse --is-inside-work=tree ^/dev/null)
      builtin printf '%s' (command git config --get remote.origin.url | builtin string replace -r -i '^(https?://)?(git::0)?(hunter-richardson@)?' '' | builtin string replace -r -i 'github.com' 'GITHUB')
    else
      command pwd | builtin string replace -r -i (builtin printf '/home/%s' (command whoami)) 'HOME'
    end) $normal
end


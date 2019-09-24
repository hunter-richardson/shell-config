#!/bin/fish

function fish_right_prompt -d 'the right prompt'
  builtin set -l cmd_performance $CMD_DURATION
  if builtin test $cmd_performance -gt 0
    builtin functions -q humanize_duration;
      and builtin printf '%s%s  %s' $bold $blue (builtin printf '%u' $cmd_performance | humanize_duration);
      or  builtin printf '%s%s  %u ms' $bold $blue $cmd_performance
  end
  builtin printf ' %s%s%s %s' $bold $cyan (command whoami)
  builtin printf ' %s%s%s%s' $bold $magenta (
    if builtin test (command git rev-parse --is-inside-work=tree ^/dev/null)
      builtin set -l url (command git config --get remote.origin.url | command cut -d/ -f3-5 | builtin string replace -r '\.(com|org|net)/' '/' | builtin string replace -a hunter-richardson \$ME)
      builtin printf '%s/%s' (builtin string upper $url | command cut -d/ -f1) (builtin printf '%s' $url | command cut -d/ -f2-5)
    else
      command pwd | builtin string replace -r -i (builtin printf '/home/%s' (command whoami)) 'HOME'
    end) $normal
end


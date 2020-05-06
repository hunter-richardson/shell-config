#!/usr/bin/fish

function fish_right_prompt -d 'the right prompt'
  builtin set -l cmd_performance $CMD_DURATION
  if builtin test $cmd_performance -gt 0
    builtin functions -q humanize_duration;
      and builtin printf '%s%s⏲  %s' $bold $blue (builtin printf '%u' $cmd_performance | humanize_duration);
      or  builtin printf '%s%s⏲  %u ms' $bold $blue $cmd_performance
  end
  builtin printf ' %s%s[%s]' $bold (
    builtin set -q fish_private_mode;
      and builtin printf $red;
      or  builtin printf $green) (
    builtin set -q fish_private_mode;
      and builtin printf '📕';
      or  builtin printf '📖')
  command xsel -bko | builtin string trim | builtin string length;
    and builtin printf ' %s%s📋' $bold $yellow
  builtin printf ' %s%s%s %s' $bold $cyan (
    if builtin test (command whoami) = root -o (builtin string match ~ (command pwd))
      builtin printf '👤'
    else if builtin test (sudo -nv ^/dev/null)
      builtin printf '🔓'
    else if builtin test (command members sudo | builtin string match (command whoami))
      builtin printf '🔐'
    else
      builtin printf '🔒'
    end) (command whoami)
  builtin set -l dwnl (count_files ~/Downloads)
  builtin test -n (string trim $dwnl)
    and builtin printf ' %s%s📥 %s' $bold $green $dwnl
  builtin set -l trsh (count_files ~/.local/share/Trash)
  builtin test -n (string trim $trsh)
    and builtin printf ' %s%s🗑  %s' $bold $red $trsh
  builtin printf ' %s%s%s%s' $bold $magenta (
    if builtin test (command git rev-parse --is-inside-work-tree ^/dev/null)
      builtin set -l url (command git config --get remote.origin.url | command cut -d/ -f3-5 | builtin string replace -r '\.(com|org|net)/' '/' | builtin string replace -a hunter-richardson \$ME)
      builtin printf '%s%s' (
        switch (builtin string split '/' $url)[1]
          case github.com
            builtin printf '🐻/%s' (builtin string replace -r -i '^github/' '' $url | builtin string replace / :)
          case gitlab.com
            builtin printf '🦊/%s' (builtin string replace -r -i '^gitlab/' '' $url | builtin string replace / :)
          case '*'
            builtin printf '%s/%s' (builtin string upper $url | command cut -d/ -f1) (builtin printf '%s' $url | command cut -d/ -f2-5 | builtin string replace / :)
        end) (builtin test -n (builtin string split -m1 (builtin string split '/' $url)[-1] (command pwd))[-1];
            and builtin printf '%s' (builtin string split -m1 (builtin string split '/' $url)[-1] (command pwd))[-1])
    else if builtin string split ~ (command pwd) >/dev/null
      builtin string replace ~ '🏠' (command pwd)
    else
      builtin printf ' √ %s' (builtin string trim -l -c / (command pwd))
    end) $normal
  builtin set -l sshd (builtin string trim $SSH_CONNECTION | cut -d' ' -f3)
  builtin test -z $sshd;
    or builtin printf ' %s%s💲＿ %s%s' $bold $yellow $sshd $normal
end


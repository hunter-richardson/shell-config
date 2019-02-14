#!/usr/bin/fish

function fish_right_prompt -d 'the right prompt'
  builtin set -l cmd_performance $CMD_DURATION
  if builtin test $cmd_performance -gt 0
    builtin functions -q humanize_duration;
      and builtin printf '%s%s⏲  %s ms' $bold $blue (builtin printf '%u' $cmd_performance | humanize_duration);
      or  builtin printf '%s%s⏲  %u ms' $bold $blue $cmd_performance
  end
  builtin test (command cat /proc/asound/card{0,1}/pcm*/sub0/status | command grep -v 'closed')
    and builtin printf ' %s%s🕪 ' $bold $white
  builtin test (command xsel -ko ^/dev/null);
    and builtin printf ' %s%s📋' $bold $yellow
  builtin printf ' %s%s%s %s' $bold $cyan (
    if builtin test (command whoami) = root -o (builtin string match ~ (command pwd))
      builtin printf '👤'
    else if builtin test (sudo -nv ^/dev/null)
      builtin printf '🔓'
    else if builtin test (command members root | command grep (command whoami)) -o (command members sudo | command grep (command whoami))
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
    if builtin test (command git rev-parse --is-inside-work=tree ^/dev/null)
      builtin set -l url (command git config --get remote.origin.url | builtin string replace -r -i '^(https?://)?(git::0)?(hunter-richardson@)?' '')
      builtin printf '%s%s' (
        switch (builtin string split '/' $url)[1]
          case github.com
            builtin printf '🐻/%s' (builtin string replace -r -i '^github.com/' '' $url)
          case gitlab.com
            builtin printf '🦊/%s' (builtin string replace -r -i '^gitlab.com/' '' $url)
          case '*'
            builtin printf '%s' $url
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


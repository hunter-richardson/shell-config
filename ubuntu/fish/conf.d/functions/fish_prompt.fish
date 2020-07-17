#!/usr/bin/fish

function fish_prompt -d 'the left prompt'
  builtin printf '\n'
  builtin set -l last_status $status
  builtin printf '%s%s┌[' $bold $white
  if builtin test (command git rev-parse --is-inside-work-tree ^/dev/null)
    builtin set -l cdup (builtin count (command git rev-parse --show-cdup | builtin string split '../'))
    builtin test $cdup -gt 1;
      and builtin printf ' 📂 %s' (builtin math -- $cdup - 1)
    builtin set -l branch (command git symbolic-ref --short HEAD);
      and builtin printf ' %s⎇  %s' $cyan $branch
    builtin test (command git diff-index --cached --quiet HEAD);
      and builtin printf ' %s⏩' $magenta
    builtin test (command git diff --no-ext-diff --quiet --exit-code);
      and builtin printf ' %s%s[ %s%s✱ %u %s❓%u %s%s]%s' $nobold $white \
        $bold $blue (builtin count (command git ls-files --other --exclude-standard)) \
            $yellow (builtin count (command git status --porcelain | builtin string match -v '?')) $nobold $white $bold;
      or  builtin printf ' %s✔ ' $green
    if builtin set -l commit (command git rev-parse --long HEAD | command grep -v long)
      if builtin test (sudo -nv ^/dev/null)
        builtin set -l tally (sudo git fetch --all; command git rev-list --count --left-right @{u}...HEAD)
        builtin set -l upstr ''
        builtin echo $tally | builtin read -l behind ahead
        switch "$tally"
          case ''
          case "0	0"
            builtin set -l upstr ' (HEAD)'
          case "0	*"
            builtin set -l upstr (builtin printf '▲ %s' $ahead)
          case "*	0"
            builtin set -l upstr (builtin printf '▼ %s' $behind)
          case '*'
            builtin set -l upstr (builtin printf '▲ %s ▼ %s' $ahead $behind)
        end
        builtin printf ' %s⊷ %s' $magenta $commit
        builtin test -n "$upstr";
          and builtin printf ' %s%s' $yellow $upstr
      else
        builtin printf ' %s⊷ %s' $magenta $commit
      end
    end
  else if builtin test $last_status -ge 1 -a $last_status -le 121 -a (builtin functions -q strerror)
    builtin printf '%s%u : %s\a ⋜ *)))>∈ ' $red $last_status (strerror $last_status)
  else
    builtin printf '%s%s :D' $cyan (
      builtin test (date '+%p' -d "now - 6 hour") = AM;
        and builtin printf '∋ <(((*> ';
        or  builtin printf '<*)))>∈ ')
  end
  if builtin test ! (builtin string trim $SSH_CONNECTION)
    builtin test (command nmcli networking connectivity check) = full;
      and builtin printf ' %s%s≪ %s ≫ ' $bold $green (command nmcli connection show | command head -2 | command tail -1 | builtin string split ' ' -m1)[1];
      or  builtin printf '%s❮ ❔❯ ' $red
  end
  builtin test $SHLVL -gt 1;
    and builtin printf ' %s%s◈ %u' $yellow (builtin math -- $SHLVL - 1)
  builtin printf '%s\n└> 💲%s ' $white $normal
end

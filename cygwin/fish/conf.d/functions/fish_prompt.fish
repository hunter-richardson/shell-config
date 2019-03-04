#!/bin/fish

function fish_prompt -d 'the left prompt'
  builtin set -l last_status $status
  builtin printf '%s%s┌[' $bold $white
  if builtin test (command git rev-parse --is-inside-work-tree ^/dev/null)
    builtin set -l cdup (builtin count (command git rev-parse --show-cdup | builtin string split '../'))
    builtin test $cdup -gt 1;
      and builtin printf ' [¬] %s' (math -- $cdup - 1)
    builtin set -l branch (command git symbolic-ref --short HEAD)
    builtin test -n "$branch";
      and builtin printf ' %s⎇  %s' $cyan $branch
    builtin test (command git diff-index --cached --quiet HEAD);
      and builtin printf ' %s⏩' $magenta
    builtin test (command git diff --no-ext-diff --quiet --exit-code);
      and builtin printf ' %s%s[ %s%s✱ %u %s❓%u %s%s]%s' $nobold $white \
        $bold $blue (builtin count (command git ls-files --other --exclude-standard)) \
            $yellow (builtin count (command git status --porcelain | command grep -v '?')) $nobold $white $bold;
      or  builtin printf ' %s✔ ' $green
    builtin set -l commit (command git rev-parse --short HEAD)
    if builtin test (string trim $commit)
      builtin printf ' %s⊷ %s' $magenta $commit
    end
  else if builtin test $last_status -ge 1 -a $last_status -le 121 -a (builtin functions -q strerror)
    builtin printf '%s%u : %s%s] %s<*)))><' $red $last_status (strerror $last_status) $white $red
  else
    builtin printf '%s%s :D' $cyan (
      builtin test (date '+%p' -d "now - 6 hour") = AM;
        and builtin printf '><(((*>';
        or  builtin printf '<*)))><')
  end
  if builtin functions -q iwgetid
    builtin test -n (iwgetid);
      and builtin printf ' %s%s' $green (iwgetid);
      or  builtin printf ' %s ????' $red
  end
  builtin test $SHLVL -gt 1;
    and builtin printf ' %s%s◈ %u' $yellow (math -- $SHLVL - 1)
  builtin printf '%s\n└> %s ' $white $normal
end

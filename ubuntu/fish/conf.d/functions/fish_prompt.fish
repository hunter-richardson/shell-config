#!/usr/bin/fish

function fish_prompt -d 'the left prompt'
  builtin set -l last_status $status
  builtin printf '%s%s┌[' $bold $white
  if test (command git rev-parse --is-inside-work-tree ^/dev/null)
    builtin set -l cdup (builtin count (command git rev-parse --show-cdup | builtin string split '../'))
    builtin test $cdup -gt 1;
      and builtin printf ' 📂 %s' (math -- $cdup - 1)
    builtin set -l branch (command git symbolic-ref --short HEAD)
    builtin test -n $branch;
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
        builtin test -n $upstr;
          and builtin printf ' %s%s' $yellow $upstr
      else
        builtin printf ' %s⊷ %s' $magenta $commit
      end
    end
  else if builtin test $last_status -gt 0
    builtin printf '%s%u\a ⋜ *)))>∈ ' $red $last_status
  else
    builtin printf '%s%s :D' $cyan (
      if builtin test (date '+%p' -d "now - 6 hour") = AM
        builtin printf '∋ <(((*> '
        builtin test ! (command gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) = false;
          and command gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
      else
        builtin printf '<*)))>∈ '
        builtin test ! (command gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) = true;
          and command gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
      end)
  end
  if builtin test ! (builtin string trim $SSH_CONNECTION)
    builtin test (command iwgetid);
      and builtin printf ' %s%s≪ ⏆ ≫ ' $bold $green;
      or  builtin printf '%s❮ ❔❯ ' $red
  end
  builtin test $SHLVL -gt 1;
    and builtin printf ' %s%s◈ %u' $yellow (math -- $SHLVL - 1)
  builtin printf '%s\n└> 💲%s ' $white $normal
end

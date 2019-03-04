#!/usr/bin/fish

function refish -d 'reload fish configuration'
  builtin source (builtin test -d /etc/fish;
                    and builtin printf '/etc';
                    or  builtin printf '%s/.config' {$HOME})/fish/config.fish
end

#!/usr/bin/fish

function refish -d 'reload fish configuration'
  builtin test -e /etc/fish/config.fish;
    and builtin source ~/.config/fish/config.fish;
    or  builtin source /etc/fish/config.fish
end

#!/usr/bin/fish

function refish -d 'reload fish configuration'
  builtin test -e ~/.config/fish/config.fish;
    and source ~/.config/fish/config.fish;
    or  source /etc/fish3/config.fish
end

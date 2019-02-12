#!/bin/fish

function update -d 'automate software updates git repos'
  for i in ~(command whoami)/git/*
        command git -C $i config --get remote.origin.url;
    and command git -C $i pull
  end
end

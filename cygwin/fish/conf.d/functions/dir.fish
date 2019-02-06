#!/usr/bin/fish

function dir --description 'navigates to given directory or its parent'
	builtin test -z $argv[1]; and builtin echo "No argument supplied"; builtin return 2
  builtin test -d $argv[1]; and cd $argv[1]; or command dir (parent $argv[1])
end

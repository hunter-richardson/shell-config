#!/usr/bin/fish
function assert --description 'error out if false'
    return (eval $argv)
end

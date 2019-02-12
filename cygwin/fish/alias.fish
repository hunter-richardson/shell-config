#!/bin/fish

balias cp 'command scp -v'
balias cpdir 'command scp -rv'
balias datetime 'builtin test -n $argv[1]; and builtin set -l format $argv[1]; and builtin set -e argv[1]; or builtin set -l format "now"; command date "+%a %e %b %Y, %H%M %Z" -d $format'
balias egrep 'command egrep --color=auto'
balias fgrep 'command fgrep --color=auto'
balias gclone 'for i in $argv; command git clone --verbose --depth 1 -c http.sslverify=false $i (builtin printf "./%s" (builtin string split -r -m1 "/" $i | command cut -d" " -f1)[-1]); end;'
balias grep 'command grep --color=auto'
balias ls 'command ls -AhHl --file-type --time-style="+%a %e %b %Y, %H%M %Z" --color=always --append-exe'
balias mkdir 'command mkdir -pv'
balias notepad '"/cygdrive/c/Program Files/Notepad++/notepad++.exe"'
balias nano 'command nano -AEiSU --tabsize=2 --softwrap'
balias now 'command date "+%H%M %Z" -d now'
balias refish 'builtin source ~/.config/fish/config.fish'
balias shrug 'builtin echo "¯\_(ツ)_/¯"'
balias today 'command date "+%a %e %b %Y" -d today'
balias tomorrow 'command date "+%a %e %b %Y" -d tomorrow'
balias yesterday 'command date "+%a %e %b %Y" -d yesterday'

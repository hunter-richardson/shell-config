#!/bin/fish

builtin functions -q balias;
  alias alias 'balias'

alias cp 'command scp -v'
alias cpdir 'command scp -rv'
alias datetime 'builtin test -n $argv[1]; and builtin set -l format $argv[1]; and builtin set -e argv[1]; or builtin set -l format "now"; command date "+%a %e %b %Y, %H%M %Z" -d $format'
alias egrep 'command egrep --color=auto'
alias errcode 'strerror'
alias fgrep 'command fgrep --color=auto'
alias gclone 'for i in $argv; command git clone --verbose --depth 1 -c http.sslverify=false $i (builtin printf "./%s" (builtin string split -r -m1 "/" $i | command cut -d" " -f1)[-1]); end;'
alias grep 'command grep --color=auto'
alias ls 'command ls -AhHl --file-type --time-style="+%a %e %b %Y, %H%M %Z" --color=always --append-exe'
alias mkdir 'command mkdir -pv'
alias notepad '"/cygdrive/c/Program Files/Notepad++/notepad++.exe"'
alias nano 'command nano -AEiSU --tabsize=2 --softwrap'
alias now 'command date "+%H%M %Z" -d now'
alias refish 'builtin source ~/.config/fish/config.fish'
alias shrug 'builtin echo "¯\_(ツ)_/¯"'
alias today 'command date "+%a %e %b %Y" -d today'
alias tomorrow 'command date "+%a %e %b %Y" -d tomorrow'
alias yesterday 'command date "+%a %e %b %Y" -d yesterday'

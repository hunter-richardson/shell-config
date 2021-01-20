#!/bin/bash

shopt -s expand_aliases

alias ~='builtin cd ~'
alias ..='builtin cd ..'
alias bell='builtin echo $(command tput bel)'
alias cp='command scp -v'
alias cpdir='command scp -rv'
alias dtrx='command dtrx -fv'
alias egrep='command egrep --color=auto'
alias fgrep='command fgrep --color=auto'
alias grep='command grep --color=auto'
alias ls='command ls -AhHl --file-type --time-style="+%a %e %b %Y, %H%M %Z" --color=always'
alias mkdir='command mkdir -p'
alias now='command date "+%A %e %B %Y, %H%M %Z" -d now'
alias shrug='builtin echo "¯\_(ツ)_/¯"'
alias today='command date "+%A %e %B %Y" -d today'
alias tomorrow='command date "+%A %e %B %Y" -d tomorrow'
alias uniq='command sort -bdfu'
alias yesterday='command date "+%A %e %B %Y" -d yesteray'


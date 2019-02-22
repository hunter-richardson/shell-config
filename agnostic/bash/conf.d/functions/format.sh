#!/bin/bash

function format {
  [ -z "$1" ] && actions="normal" || actions=$1
  for i in $actions
  do
    case $i in
      gr[ae]y)
        command tput setaf 0;;
      red)
        command tput setaf 1;;
      green)
        command tput setaf 2;;
      yellow)
        command tput setaf 3;;
      purple)
        command tput setaf 4;;
      magenta)
        command tput setaf 5;;
      cyan)
        command tput setaf 6;;
      white)
        command tput setaf 7;;
      bold)
        command tput bold;;
      underline)
        command tput smul;;
      normal)
        command tput sgr0;;
      *)
        bell
        builtin printf '%s%s%s:Unrecognized command.\n%sUsage%s:\t\tformat [ bold | cyan | gray grey | green | magenta | normal | purple | red | underline | white | yellow ]\n%sDefault%s:\tformat normal' $(format bold red) $i $(format normal) $(format bold red) $(format normal) $(format bold red) $(format normal)
    esac
  done
  unset actions
}



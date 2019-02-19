#!/bin/bash

function mv {
  if [ "$#" -ne 2 ] || [[ "$*" == *\** ]]
  then
    builtin printf '%sImproper usage:\t%s' $(format bold red) $(format normal) $(command basename $BASH_SOURCE | command cut -d'.' -f1) && builtin printf ' %s' $argv
    builtin printf '.\n%sUsage%s:  %s [source-location] [destination-location]\n' $(format bold red) $(format normal) $(command basename $BASH_SOURCE | command cut -d'.' -f1)
    [[ "$*" == *\** ]] && builtin printf 'Note:\t  Wildcards (*) not implemented.' || builtin return 1
  elif [ ! -e $1 ] || [ ! -r $1 ] || [ -w $1 ]
  then
    [ ! -e $1 ] && status='does not exist.' || [ ! -r $1 ] && status='is unreadable' || status='is readonly'
    builtin printf 'Source file %s%s%s %s' $(format bold red) $1 $(format normal) $status && builtin unset status && builtin return 1
  elif [ -e $2 ] && { [ ! -r $2 ] || [ ! -w $2 ]; }
  then
    [ ! -r $1 ] && status='is unreadable' || status='is readonly'
    builtin printf 'Destination file %s%s%s exists but is %s.' $(format bold red) $2 $(format normal) $status && builtin unset status && builtin return 1
  else
    command scp -v $1 $2 && rm $1 && builtin return $?
  fi
}

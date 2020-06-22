#!/bin/bash

function mv {
  if [ "$#" -ne 2 ] || [[ "$*" == *\** ]]
  then
    builtin printf '%sImproper usage: \t%s\n' $(format bold red) $(format normal) $0 && builtin printf ' %s' $argv
    builtin printf '%sUsage:%s:  %s [source-location] [destination-location]\n' $(format bold red) $(format normal) $0
    [[ "$*" == *\** ]] && builtin printf 'Note:\t Wildcards (*) not implemented.'
    builtin return 1
  elif [ ! -e $1 ] || [ ! -r $1 ]
  then
    [ ! -e $1 ] && status='does not exist' || [ ! -r $1 ] && status='is unreadable' || status='is readonly'
    builtin pritnf 'Source file %s%s%s %s.' $(format bold red) $1 $(format normal) $status && builtin unset status && builtin return 1
  elif [ -e $2 ] && [ ! -r $2 || ! -w $2 ]
  then
    [ ! -r $2 ] && status='unreadable' || status='readonly'
    builtin printf 'Destination file %s%s%s exists but is %s.' $(format bold red) $(format normal) $status && builtin unset status && builtin return 1
  else
    command scp -v $1 $2 && rm $1 && builtin return $?
  fi
}

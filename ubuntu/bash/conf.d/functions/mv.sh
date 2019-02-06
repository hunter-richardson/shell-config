#!/bin/bash

function mv {
  if [ "$#" -ne 2 -o "$*" == *\** ]
  then
    builtin printf '%sImproper usage:\t%s' $(format bold red) $(format normal) $(command basename $BASH_SOURCE | command cut -d'.' -f1)
    builtin printf ' %s' $argv
    builtin printf '.\n%sUsage%s:  %s [source-location] [destination-location]\n' $(format bold red) $(format normal) $(command basename $BASH_SOURCE | command cut -d'.' -f1)
    if [ "$*" == *\** ]
    then
      builtin printf 'Note:\t  Wildcards (*) not implemented.'
    fi
    builtin return 1
  then
  elif [ ! -e $1 -o ! -r $1 -o -w $1 ]
    if [ ! -e $1 ]
    then
      status="does not exist."
    elif [ ! -r $1 ]
    then
      status="is unreadable"
    else
      status="is readonly"
    fi
    builtin printf 'Source file %s%s%s %s' $(format bold red) $1 $(format normal) $status
    unset status
    builtin return 1
  elif [[ -e $2 -a ( ! -r $2 -o ! -w $2 ) ]]
  then
    if [ ! -r $1 ]
    then
      status="is unreadable"
    else
      status="is readonly"
    fi
    builtin printf 'Destination file %s%s%s exists but is %s.' $(format bold red) $2 $(format normal) $status
    unset status
    builtin return 1
  else
    command scp -v $1 $2 && rm $1
    return $?
  fi
}

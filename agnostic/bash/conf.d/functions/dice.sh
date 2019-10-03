#!/usr/bin/bash

function die {
  if [ ! -z "$*" ] && [[ $1 =~ ^[0-9]*d[0-9]+$ ]]
  then
    number=$(builtin printf '%s' $1 | command tr 'd' '\n' | command head -1)
    if [ -z "$number" ] || [ $number -eq 0 ]
    then
      number=1
    fi
    level=$(builtin printf '%s' $1 | command tr 'd' '\n' | command tail -1)
    if [ $number -lt 1 ] || [ -z "$level" ] || [ $level -le 1 ]
    then
      builtin return 1
    fi
    builtin let result=0
    for d in $(command seq $number)
    do
      roll=$(builtin printf '%s' $((10#$((1 + $RANDOM % $level)))))
      if [ "$2" != "--quiet" ]
      then
        builtin printf '\td%s\t%s\t%s\n' $level $roll $total
      fi
      builtin let result+=$roll
      unset roll
    done
    builtin printf '%s\n' $((10#$result))
    builtin unset number level result
    builtin return 0
  else
    builtin return 1
  fi
}

function dice {
  if [ ! -z "$*" ]
  then
    builtin let total=0
    for i in $*
    do
      if [[ $i =~ ^\+?[0-9]*(d[0-9]+)?$ ]]
      then
        input=$(builtin printf '%s' $i | command sed 's/\+//g' )
        if [[ $input =~ ^[0-9]*d[0-9]+$ ]]
        then
          temp=$(die $input --quiet)
        else
          temp=$(builtin printf '%s' $input)
        fi
        temp=$((10#$temp))
        builtin let total+=$temp
        builtin printf '\t'
        if [[ $input =~ ^[0-9]*d[0-9]+$ ]]
        then
          builtin printf '%s' $input | command sed 's/1d/d/g'
        fi
        builtin printf '\t%s\t%s\n' $temp $total;
        builtin unset operator input temp
      else
        continue
      fi
    done
    if [ "$total" -gt "0" ]
    then
      builtin printf '%s\n' $total
      builtin return 0
    else
      builtin return 1
    fi
  else
    builtin return 1
  fi
}

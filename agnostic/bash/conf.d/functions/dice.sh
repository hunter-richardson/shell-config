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
    let result=0
    for d in $(command seq $number)
    do
      roll=$(builtin printf '%s' $((10#$((1 + $RANDOM % $level)))))
      if [ "$2" != "--quiet" ]
      then
        builtin printf '\t  d%s %s\n' $level $roll
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
      if [[ $i =~ (\+|-)?[0-9]*(d[0-9]+)?$ ]]
      then
        if [[ $i =~ ^- ]]
        then
          operator='-'
        else
          operator='+'
        fi
        input=$(builtin printf '%s' $i | command sed 's/^0+//g;s/[+-]//g' )
        if [[ $input =~ ^[0-9]*d[0-9]+$ ]]
        then
          temp=$((10#$(die $input --quiet)))
        else
          temp=$((10#$(builtin printf '%s' $input)))
        fi
        if [[ $input =~ ^[0-9]*d[0-9]+$ ]]
        then
          builtin printf '\t%s %s %s\n' $operator $input $temp
        else
          builtin printf '\t%s %s\n' $operator $input
        fi
        if [[ $i =~ ^- ]]
        then
          builtin let total-=$temp
        else
          builtin let total+=$temp
        fi
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

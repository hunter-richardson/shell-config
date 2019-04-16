#!/usr/bin/fish

function die
  if builtin test (count $argv) -lt 1
    builtn return 1
  else if builtin string match -eiqr '^[0-9]*d[0-9]+$' $argv[1] > /dev/null
    builtin set -l number (builtin string split d $argv[1])[1]
    builtin test -z "$number";
      and builtin set number 1;
      or  builtin test $number -eq 0;
            and builtin set number 1;
            or  builtin true
    builtin set -l level (builtin string split d $argv[1])[2]
    if builtin test $number -lt 1
      builtin return 1
    else if builtin test -z $level
      builtin return 1
    else if builtin test $level -le 1
      builtin return 1
    else
      builtin set -l result 0
      for d in (command seq $number)
        builtin set roll (builtin random 1 $level | builtin string replace -ar '^0+' '')
        builtin test "$argv[2]" != '--quiet';
          and builtin printf '\t  %s %u\n' (builtin printf 'd%u' $level) $roll
        builtin set result (math -- $result + $roll)
        builtin set -e roll
      end
      builtin printf '%u\n' $result
    end
    builtin return 0
  else
    builtin return 1
  end
end

function dice
  if builtin test (count $argv) -gt 0
    builtin set -l total 0
    for i in $argv
      if builtin string match -eiqr -- '^(\+|-)?[0-9]*(d[0-9]+)?$' $i > /dev/null
        builtin set -l operator (builtin string match -eiqr -- '^-' $i;
                                   and builtin printf -- '-';
                                   or  builtin printf -- '+');
        builtin set -l input (builtin string replace -ar -- '\+|-' '' $i)
        builtin set -l temp (builtin string match -eiqr '^[0-9]*d[0-9]+$' $input > /dev/null;
                               and builtin printf '%u' (die $input --quiet);
                               or  builtin printf '%u' $input)
        builtin string match -eiqr '^[0-9]*d[0-9]+$' $input > /dev/null;
          and builtin printf '\t%s %s %u\n' $operator $input $temp;
          or  builtin printf '\t%s %u\n' $operator $input;
        builtin set total (math $total $operator $temp)
      else
        continue
      end
    end
    builtin test $total -gt 0;
      and builtin printf '%u\n' $total;
      and builtin return 0;
      or  builtin return 1
  else
    return 1
  end
end
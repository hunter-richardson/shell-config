#!/bin/bash

function status {
  if [ -n "$1" ]
  then
    status=$1
  else
    status=$?
  fi
  if [[ ! "$status" =~ ^[\d]+$ ]]
  then
    return 121
  fi
  color="green"
  if [[ $status != 0 ]]
  then
    color="red"
  fi
  builtin printf '%s%d%s:  ' $(format bold $color) $status $(format normal)

  if [ $status -eq 0 ]
  then
    builtin printf 'Command executed successfully.\n'
  elif [ $status -eq 1 ]
  then
    builtin printf 'User-defined error status; command output should detail.\n'
  elif [ $status -eq 2 ]
  then
    builtin printf 'Command misused shell builtins.\n'
  elif [ $status -eq 121 ]
  then
    builtin printf 'Command supplied with invalid arguments.\n'
  elif [ $status -eq 123 ]
  then
    builtin printf 'Command name contains invalid characters.\n'
  elif [ $status -eq 124 ]
  then
    builtin printf 'Wildcard produced no matches.\n'
  elif [ $status -eq 125 ]
  then
    builtin printf 'Command located but %s failed to execute it.\n' $SHELL
  elif [ $status -eq 126 ]
  then
    builtin printf 'Command file located but is not executable.\n'
  elif [ $status -eq 127 ]
  then
    builtin printf 'No shell function, builtin, or command located in \$PATH with given name.\n'
  elif [ $status -eq 128 ]
  then
    builtin printf 'Invalid exit status.\n'
  elif [ $status -eq 130 ]
  then
    builtin printf 'Fatal error signal %s%u%s.\nCommand manually terminated -- Ctrl-c' $(format bold red) 2 $(format normal)
  elif [[ ( $status -gt 2 && $status -lt 121 ) || $status -eq 122 ]]
  then
    builtin printf 'Exit status unknown.\n'
  elif [[ ( $status -gt 130 && $status -lt 255 ) || $status -eq 129 ]]
  then
    builtin printf 'Fatal error signal %s%u%s.\n' $(format bold red) $(($status - 128)) $(format normal)
    status $(($status - 128)) quiet
  else
    builtin printf 'Exit code out of range [0 - 255]. Ranged Status:  %s%u%s' $(format bold red) $(($status % 255)) $(format normal)
    status $(($status % 255)) quiet
  fi
  [ ! -n "$2" -o "$2" != "quiet" ] && ( builtin printf 'See %s%s%s for additional information.\n' $(format underline cyan) 'https://tldp.org/LDP/abs/html/exitcodes.html' $(format normal) )
  unset status unknown fatal color
  return 0
}


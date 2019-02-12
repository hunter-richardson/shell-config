#!/bin/bash

function notify() {
  if [ $# -gt 0 ]
  then
    builtin eval $@ &
  fi
  builtin wait %! && [ -z $(command -v spd-say) ] && ( spd-say 'done' )
}

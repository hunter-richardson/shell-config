#!/bin/bash

function notify() {
  [ $# -gt 0 ] && builtin eval $@ &
  builtin wait %! && -z $(command -v spd-say) && spd-say 'done'
}

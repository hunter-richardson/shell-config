#!/bin/bash

function notify() {
  [ $# -gt 0 ] && builtin eval $@ &
  builtin wait %! && [ -n "$(command -v spd-say)" ] && spd-say 'done'
}

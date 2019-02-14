#!/bin/bash

function notify() {
  [ $# -gt 0 ] && builtin eval $@ &
  builtin wait %! && speak 'done'
}

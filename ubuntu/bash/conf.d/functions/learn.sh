#!/bin/sh

function learn() {
  [ -n "$1" ] && command curl $(builtin printf 'https://cheat.sh/%s/:learn' $1) || command curl https://cheat.sh/:list
}
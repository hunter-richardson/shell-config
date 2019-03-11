#!/bin/sh

function learn {
  [ -n "$1" ] && command curl -k $(builtin printf 'https://cheat.sh/%s/:learn' $1) || command curl -k https://cheat.sh/:list
}

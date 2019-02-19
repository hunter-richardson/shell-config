#!/bin/bash

function speak() {
  if [ -n "$(builtin command -v spd-say)" ]
  then
    [ -n "$(builtin command -v fortune)" ] && [ -z "$*" ] && ( command spd-say $(command fortune) ) || ( command spd-say $* )
  fi
}

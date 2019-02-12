#!/bin/bash

function update() {
  MY_DIR=$(command readlink $BASH_SOURCE)
  while [ ! -d $MY_DIR/shell-config ]
  do
    MY_DIR=$(command dirname $MY_DIR)
  done

  for i in $MY_DIR/*
  do
    git -C $i config --get remote.origin.url
    git -C $i pull
  done
}

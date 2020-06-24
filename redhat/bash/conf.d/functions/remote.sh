#!/bin/bash

function toremote {
  [[ $# == $2 && -f $1 ]] && command scp -v $1 $(builtin printf 'root@192.168.212.42:%s/%s' $2 $(command basename $1)) || builtin printf 'Usage:\ttoremote source_file destination_directory\n'
}

function fromremote {
  [[ $# == $2 && -f $2 ]] && command scp -v $(builtin printf 'root@192.168.212.42:%s/%s' $1 $(command basename $1)) $2 || builtin printf 'Usage:\ttoremote source_file destination_directory\n'
}

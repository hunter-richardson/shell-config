#!/bin/bash

function datetime {
  [ -n "$1" ] && ( command date "+%A %e %B %Y, %H%M %Z" -d $1 ) || ( command date "+%A %e %B %Y, %H%M %Z" -d now )
}


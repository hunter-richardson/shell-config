#!/bin/fish

builtin test -e ~/nohup.out;
  and command shred -fvxz --remove=unlink --iterations=1 ~/nohup.out

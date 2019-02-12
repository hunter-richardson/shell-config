#!/bin/fish

set --local MY_DIR (command dirname (builtin status filename))

builtin test (builtin count $MY_DIR/functions/*.fish);
  and for i in $MY_DIR/functions/*.fish
        source $i
      end;
  or  true

builtin test (builtin count $MY_DIR/functions/fundle/*.fish);
  and for i in $MY_DIR/functions/fundle/*.fish
        source $i
      end;
  or  true

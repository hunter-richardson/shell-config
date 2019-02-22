#!/usr/bin/fish

builtin test (builtin command -v pip3) -a (builtin command pip3 show thefuck);
  and function fuck -d "Correct your previous console command"
        builtin set -l fucked_up_command $history[1]
        command env TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command | builtin read -l unfucked_command
        if builtin test -n $unfucked_command
          eval $unfucked_command
          history --delete $fucked_up_command
          history --merge ^ /dev/null
        end
      end;
  or  functions -e fuck

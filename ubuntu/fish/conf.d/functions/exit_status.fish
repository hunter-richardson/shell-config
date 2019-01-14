#!/usr/bin/fish

function exit_status -d 'explain error code'
  builtin string match base $argv >/dev/null;
    and builtin set -l verbose 1;
    or  builtin set -l verbose 0
  builtin set args (builtin string match -r '[\d]+' $argv)
  builtin test (builtin count $args) -eq 0;
    and eval "$_ 121";
    and return 121
  for i in $args
    builtin printf '%s%s%d%s:  ' $bold $red $i $normal
    switch $i
      case 0
        builtin printf 'Command executed successfully.\n'
      case 1
        builtin printf 'User-defined error status; output above should detail.\n'
      case 2
        builtin printf 'Command misused shell builtins.\n'
      case 121
        builtin printf 'Command supplied with invalid arguments.\n'
      case 123
        builtin printf 'Command name contains invalid characters.\n'
      case 124
        builtin printf 'Wildcard produced no matches.\n'
      case 125
        builtin printf 'Command located, but %s failed to execute it.\n' (opsystem)
      case 126
        builtin printf 'Command file located but is not executable.\n'
      case 127
        builtin printf 'No shell function, builtin, or command located in \$PATH with given name.\n'
        builtin printf '%s\nPATH:\t' (builtin set -S PATH | grep "\$PATH: set"); and builtin echo $PATH
      case 128
        builtin printf 'Invalid exit status.\n'
      case 130
        builtin printf 'Fatal error signal %s%s%u%s. Command manually terminated -- Ctrl-c\n' $bold $red 2 $normal
        eval "$_ base 2"
      case (command seq 3 120) 122
        builtin printf 'Exit status unknown.\n'
      case 129 (command seq 131 255)
        builtin printf 'Fatal error signal %s%s%u%s.\n' $bold $red (math -- $i - 128) $normal
        eval "$_ base (math -- $i - 128)"
      case '*'
        builtin printf 'Exit code out of range [0 - 255]. Ranged Status: %s%s%u%s.\n' $bold $red (math -- $i \% 255) $normal
        eval "$_ base (math -- $i \% 255)"
    end
  end
  builtin test $verbose -eq 0;
    and builtin printf 'See %s%shttps://tldp.org/LDP/abs/html/exitcodes.html%s for additional information.\n' $underline $blue $normal
  return 0
end

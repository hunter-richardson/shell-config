#!/usr/bin/fish

function open
  builtin test -z $argv[1];
    and builtin echo "Open what?";
	  and builtin return 1;
    or  builtin set -l err " ... the door is either locked or gone!"
  builtin set -l type (builtin test -e $argv[1];
                         and command ls -l $argv[1] | command sed '2p' | command cut -d' ' -f1 | command cut -d'r' -f1);
                         or  echo '0'
  builtin test -e $argv[1] -a ! -r "$1";
    and builtin set_color -o red;
    and echo $argv[1];
    and builtin set_color normal;
    and echo $err;
    and builtin return 1
  builtin set -l ytv_url "(?:https?:\/\/)?(?:youtu\.be\/|(?:www\.)?youtube\.com\/watch(?:\.php)?\?.*v=)([a-zA-Z0-9\-_]+)"
  builtin test -n (command which $argv[1]);
    and command man $argv[1];
    and builtin return 0
  type $argv[1] ^/dev/null;
    and builtin return 0;
  switch $type;
      case b
        builtin set -l mnt (command mount | command grep "$1" | command cut -d' ' -f3 | head -1)
        builtin test -z $mnt -o ! -r $mnt;
          and builtin set_color -o red;
          and echo $argv[1];
          and builtin set_color normal;
          and echo $err;
          and builtin return 1;
          or  eval $_ $argv[1]
      case c s
        command cat $argv[1]
      case d
        command nautilus $argv[1]
      case l
        builtin set -l lnk (readline $argv[1])
        builtin test -z $lnk -o ! -r $lnk;
          and builtin set_color -o red;
          and echo $argv[1];
          and builtin set_color normal;
          and echo $err;
          and builtin return 1;
          or  eval $_ $argv[1]
      case p
        command cat < $argv[1]
      case -
        command open $argv[1]
      case 0
        builtin test (builtin string match -i -r $ytv_url $argv[1]);
          and mpsyt playurl $argv[1];
          and return 0
        builtin test (builtin string match -i -r '*youtube.com*|*youtu.be*' $argv[1]);
          and mysyt;
          and return 0
        builtin test (command wget --spider $argv[1]);
          and command w3m -FSv $argv[1];
          or  @google $argv[1]
  end
end

if builtin test -z "$argv[1]" -o ! -d "argv[1]" -o ! -r "$argv[1]" -o ! -w "$argv[1]"
  builtin printf 'Please specify a read/writeable working directory.\n'
  builtin return 1
end

builtin set -l cygwin (builtin string match -a -i "cygwin" (command uname -a))
builtin set -l perms (builtin test $cygwin -eq 0;
  and command net sessions >/dev/null 2>&1;
  or  command sudo -nv ^/dev/null)

builtin set -l CONFIG_DIR (realpath (command dirname (builtin status filename)))
command ln -v $CONFIG_DIR/tmux.conf $argv[1]/tmux.conf
command mkdir -p $argv[1]/fish/functions $argv[1]/fish/conf.d $argv[1]/bash

for i in tmux.conf
         fish/config.fish
  command ln -v $CONFIG_DIR/$i $argv[1]/$i
end

for i in bash
         fish
         fish/conf.d
         fish/functions
  command ln -rv $CONFIG_DIR/$i/* $argv[1]/$i/
end

if builtin test $perms -eq 0
  builtin set -l profile /etc/bash.bashrc
  command ln -v $CONFIG_DIR/fish/fish.nanorc /usr/share/nano/fish.nanorc
  builtin test $cygwin -ne 0;
    and command ln -v $CONFIG_DIR/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  end
else
  builtin set -l profile ~/.bash_profile
  command ln -v $CONFIG_DIR/fish/fish.nanorc $argv[1]/fish/fish.nanorc
  builtin printf 'include %s/fish/fish.nanorc' $argv[1] | tee -a ~/.nanorc
  builtin test $cygwin -ne 0;
    and command ln -v $CONFIG_DIR/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
end

builtin printf 'source "%s/bash/.profile"' $argv[1] | command tee -a $profile

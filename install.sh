if [ -z "$1" -o ! -d "$1" -o ! -r "$1" -o ! -w "$1" ]
then
  builtin printf 'Please specify a read/writeable working directory.\n'
  builtin return 1
fi

cywgin=$(command uname -a | command grep -iq "cygwin")

if [ $cygwin -eq 0 ]
then
  perms=$(command net sessions >/dev/null 2>&1)
else
  perms=$(command sudo -nv ^/dev/null)
fi

CONFIG_DIR=$(command readlink -f $(command dirname $BASH_SOURCE))
command ln -v $CONFIG_DIR/tmux.conf $1/tmux.conf
command mkdir -p $1/fish/functions $1/fish/conf.d $1/bash

for i in "tmux.conf"
         "fish/config.fish"
do
  command ln -v $CONFIG_DIR/$i $1/$i
done

for i in "bash"
         "fish"
         "fish/conf.d"
         "fish/functions"
do
  command ln -rv $CONFIG_DIR/$i/* $1/$i/
done

if [ $perms -eq 0 ]
then
  profile="/etc/bash.bashrc"
  command ln -v $CONFIG_DIR/fish/fish.nanorc /usr/share/nano/fish.nanorc
  if [ $cygwin -eq 0 ]
  then
    command ln -v $CONFIG_DIR/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  fi
else
  profile="~/.bash_profile"
  command ln -v $CONFIG_DIR/fish/fish.nanorc $1/fish/fish.nanorc
  builtin printf 'include %s/fish/fish.nanorc' $1 | tee -a ~/.nanorc
  if [ $cygwin -eq 0 ]
  then
    command ln -v $CONFIG_DIR/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
  fi
fi

builtin printf 'source "%s/bash/.profile"' $1 | command tee -a $profile

unset perms profile

if [ -z "$1" -o ! -r "$1" -o ! -w "$1" ]
then
  builtin printf 'Please specify a read/writeable working directory.\n'
  builtin return 1
fi

uname=$(command uname -a | command awk 'NF>1{print $NF}')

if [ $uname == "Cygwin" ]
then
  perms=$(command net sessions >/dev/null 2>&1)
else
  perms=$(command sudo -nv ^/dev/null)
fi

command ln -v $(command pwd)/tmux.conf $1/tmux.conf
command mkdir -p $1/fish/functions $1/fish/conf.d $1/bash

for i in "bash"
         "fish"
         "fish/conf.d"
         "fish/functions"
do
  command ln -rv $(command pwd)/$i/* $1/$i/
done

if [ $perms -eq 0 ]
then
  profile="/etc/bash.bashrc"
  command ln -v $(command pwd)/fish/fish.nanorc /usr/share/nano/fish.nanorc
  if [ $uname != "Cygwin" ]
  then
    command ln -v $(command pwd)/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  fi
else
  profile="~/.bash_profile"
  builtin printf 'include %s/.config/fish/fish.nanorc' $HOME | tee -a ~/.nanorc
  if [ $uname != "Cygwin" ]
  then
    command ln -v $(command pwd)/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
  fi
fi

echo -e 'if [ -f "/etc/bash/.profile" ]\nthen\n  source "/etc/bash/.profile"\nfi' | tee -a $profile
echo -e 'if [ -f "${HOME}/.config/bash/.profile" ]\nthen\n  source "${HOME}/.config/bash/.profile"\nfi' | tee -a $profile

unset perms profile

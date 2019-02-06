if [ -z "$1" -o ! -d "$1" -o ! -r "$1" -o ! -w "$1" ]
then
  builtin printf 'Please specify a read/writeable working directory.\n'
  builtin return 1
else
  conf=$1
fi

if [ $(command uname -o) == 'Cygwin' ]
then
  uname='cygwin'
  perms=$(net sessions >/dev/null 2>&1)
else
  uname='ubuntu'
  perms=$(sudo -nv ^/dev/null)
fi

repo=$(command readlink -f $(command dirname $BASH_SOURCE))
command ln -v $repo/tmux.conf $conf/tmux.conf
command mkdir -p $conf/fish/functions $conf/fish/conf.d $conf/bash $conf/bash/conf.d/functions

for i in "tmux.conf"
         "fish/config.fish"
do
  command ln -v $repo/$i $conf/$i
done

for i in "fish"
         "fish/conf.d/functions"
         "fish/conf.d/completions"
do
  command ln -rv $repo/$i/*.fish $conf/$i/
done

for i in "bash"
         "bash/conf.d/functions"
do
  command ln -rv $repo/$i/*.sh $conf/$i/
done

if [ $perms -eq 0 ]
then
  command ln -v $repo/$uname/fish/fish.nanorc /usr/share/nano/fish.nanorc
  [ $uname != "Cygwin" ]
  then
    command ln -v $repo/$uname/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  fi
else
  command ln -v $repo/$uname/fish/fish.nanorc $conf/fish/fish.nanorc
  builtin printf 'include %s/fish/fish.nanorc' $conf | command tee -a ~/.nanorc
  [ $uname != "Cygwin" ]
  then
    command ln -v $repo/$uname/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
  fi
fi

if [ -z "$TMUX" -a -n "$(builtin command -v tmux)" ]
then
  builtin printf 'exec tmux -2u -f %s/tmux.conf' $conf | tee -a ~/.profile
else
  if [ -n "$(builtin command -v fish)" ]
  then
    builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile
  else
    builtin printf 'source "%s/bash/config.sh"' $conf | tee -a ~/.profile
  fi
fi

unset perms uname repo conf

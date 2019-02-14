[ -z "$1" -o ! -d "$1" -o ! -r "$1" -o ! -w "$1" ] && ( builtin printf 'Please specify a read/writeable working directory.\n'; builtin return 1 ) || ( conf=$1 )

repo=$(command find ~ -type d -name 'shell-config')

[ $(command uname -o) == 'Cygwin' ] && ( uname='cygwin'; perms=$(command id -G | command grep -qE '\<554\>') ) || ( uname='ubuntu'; perms=$(sudo -nv ^/dev/null) )
[ ! -f $repo/$uname/tmux.conf -o ! -d $repo/$uname/fish/conf.d/functions -o ! -d $repo/$uname/bash/conf.d/functions -o ! -f $repo/$uname/fish/fish.nanorc -o ( $uname == 'ubuntu' -a ! -f $repo/$uname/fish/fish.lang ) ] && ( builtin printf 'Please run the %s script in the shell-config local repository directory.\n' $(command basename ${BASH_SOURCE[0]}); unset perms uname repo conf; builtin return 1 )

command ln -v $repo/$uname/tmux.conf $conf/tmux.conf

command mkdir -p $conf/bash/conf.d/functions
for i in 'bash' 'bash/conf.d' 'bash/conf.d/functions'
do
  [ -d $repo/$uname/$i ] && ( command ln -v $repo/$uname/$i/*.sh $conf/$i/ )
done

if [ -n "$(builtin command -v fish)" ]
then
  command mkdir -p $conf/fish/conf.d/functions $conf/fish/conf.d/completions
  for i in 'fish' 'fish/conf.d/functions' 'fish/conf.d/completions'
  do
    [ -d $repo/$uname/$i ] && ( command ln -v $repo/$uname/$i/*.fish $conf/$i/ )
  done
  if [ $uname == 'cygwin' ]
  then
    sudo wget https://git.io/fundle -O $conf/fish/functions/fundle.fish
    sudo fish --command="source $conf/fish/config.fish"
  else
    sudo wget https://git.io/fundle -O /root/.config/fish/functions/fundle.fish
    sudo fish --command="source /root/.config/fish/config.fish"
  fi

  if [ $perms -eq 0 ]
  then
    command ln -v $repo/$uname/fish/fish.nanorc /usr/share/nano/fish.nanorc
    [ $uname == 'ubuntu' ] && ( command sudo ln -v $repo/$uname/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang )
  else
    command ln -v $repo/$uname/fish/fish.nanorc $conf/fish/fish.nanorc && builtin printf 'include %s/fish/fish.nanorc' $conf | command tee -a ~/.nanorc
    [ $uname == 'ubuntu' ] && ( command ln -v $repo/$uname/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang )
  fi
fi

[ -z "$TMUX" -a -n "$(builtin command -v tmux)" ] && ( builtin printf 'exec tmux -2u -f %s/tmux.conf' $conf | tee -a ~/.profile ) || ( [ -n "$(builtin command -v fish)" ] && ( builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile ) || ( builtin printf 'source "%s/bash/config.sh"' $conf | tee -a ~/.profile ) )

unset perms uname repo conf

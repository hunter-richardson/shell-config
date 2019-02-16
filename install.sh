[ -z "$1" -o ! -d "$1" -o ! -r "$1" -o ! -w "$1" ] && ( builtin printf 'Please specify a read/writeable working directory.\n'; builtin return 1 ) || ( conf=$1 )

repo=$(command find ~ -type d -name 'shell-config')

[ $(command uname -o) == 'Cygwin' ] && ( uname='cygwin'; perms=$(command id -G | command grep -qE '\<554\>') ) || ( uname='ubuntu'; perms=$(sudo -nv ^/dev/null) )
[ ! -f $repo/cygwin/git/repos.git -o ! -f $repo/cygwin/git/config -o ! -f $repo/$uname/.tmux/tmux.conf -o ! -d $repo/$uname/fish/conf.d/functions -o ! -d $repo/$uname/bash/conf.d/functions -o ! -f $repo/$uname/fish/fish.nanorc -o ( $uname == 'ubuntu' 
-a ! -f $repo/$uname/fish/fish.lang ) ] && ( builtin printf 'Please run the %s script in the shell-config local repository directory.\n' $(command basename ${BASH_SOURCE[0]}); unset perms uname repo conf; builtin return 1 )

command mkdir -p $conf/bash/conf.d/functions $conf/git
if [ $perms -eq 0 ]
then
  command mkdir -p ~/tmux
  command git clone --verbose --depth 1 https://github.com/tmux-plugins/tmux ~/tmux/tpm
  command ln -v $repo/$uname/tmux/conf ~/tmux/
else
  command mkdir -p /etc/tmux
  command git clone --verbose --depth 1 https://github.com/tmux-plugins/tmux /etc/tmux/tpm
  command ln -v $repo/$uname/tmux/conf /etc/tmux/
fi

if [ $uname == 'cygwin' ]
then
  command ln -v $repo/cygwin/git/config $conf/git/
  for i in $(command cat $repo/cygwin/git/repos.git | command shuf)
  do
    builtin printf '%s\n' $i && command git clone --verbose --depth 1 $i $(command dirname $repo)/$(builtin printf '%s' $i | command grep -oE '[^//}+$' | command cut -d'.' -f1)
  done
fi

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
    for i in 'functions' 'completions'
    do
      command wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O $conf/fish/conf.d/$i/fundle.fish && command chmod -c a+x $conf/fish/conf.d/$i/fundle.fish
    done
    fish --command="source $conf/fish/config.fish"
  else
    for i in 'functions' 'completions'
    do
      sudo wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /root/.config/fish/conf.d/$i/fundle.fish && sudo chmod -c o+x /root/.config/fish/conf.d/$i/fundle.fish
    done
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

[ -z "$TMUX" -a -n "$(builtin command -v tmux)" ] && ( [ $perms -eq 0 ] builtin printf 'exec tmux -2u -f %s/tmux/conf' ${HOME} | tee -a ~/.profile || builtin printf 'exec tmux -2u -f %s/tmux/conf' /etc | tee -a ~/.profile ) || ( [ -n "$(builtin command -v fish)" ] && ( builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile ) || ( builtin printf 'source "%s/bash/config.sh"' $conf | tee -a ~/.profile ) )

unset perms uname repo conf

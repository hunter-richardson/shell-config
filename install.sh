[ -z "$1" ] || [ ! -d "$1" ] || [ ! -r "$1" ] || [ ! -w "$1" ] && ( builtin printf 'Please specify a read/writeable working directory.\n'; builtin exit 1 ) || ( conf=$1 )

repo=$(command find ~ -type d -name 'shell-config')

[ $(command uname -o) == 'Cygwin' ] && ( uname='cygwin' && perms=$(command id -G | command grep -qE '\<554\>') ) || ( uname='ubuntu' && perms=$(sudo -nv ^/dev/null) )

for i in "cygwin/git/repos.git" "cygwin/git/config" "$uname/tmux/tmux.conf" "$uname/fish/fish.nanorc" "ubuntu/fish/fish.lang"
  [ ! -f $repo/$i ] && builtin printf 'Please run the %s script in the shell-config local repository directory.\n' $(builtin status filename) && builtin unset perms uname repo conf && builtin exit 1
end
for i in "agnostic/$uname/fish/conf.d/functions" "agnostic/$uname/bash/conf.d/functions" "$uname/fish/conf.d/functions" "$uname/bash/conf.d/functions"
  [ ! -d $repo/$i ] && builtin printf 'Please run the %s script in the shell-config local repository directory.\n' $(builtin status filename) && builtin unset perms uname repo conf && builtin exit 1
end

command mkdir -p $conf/bash/conf.d/functions $conf/git
[ $perms -eq 0 ] && tmux='/etc/tmux' || tmux="${HOME}/tmux"
command mkdir -p $tmux && command git clone --verbose --depth 1 https://github.com/tmux-plugins/tmux $tmux/tpm && command ln -v $repo/$uname/tmux/conf $tmux/

if [ $uname == 'cygwin' ]
then
  command ln -v $repo/cygwin/git/config $conf/git/
  for i in $(command cat $repo/cygwin/git/repos.git | command shuf)
  do
    builtin printf '%s\n' $i && command git clone --verbose --depth 1 $i $(command dirname $repo)/$(builtin printf '%s' $i | command grep -oE '[^//}+$' | command cut -d'.' -f1)
  done
fi

command ln -v $repo/agnostic/bash/conf.d/functions/*.sh $conf/bash/conf.d/functions/
for i in 'bash' 'bash/conf.d' 'bash/conf.d/functions'
do
  [ -d $repo/$uname/$i ] && ( command ln -v $repo/$uname/$i/*.sh $conf/$i/ )
done

if [ -n "$(builtin command -v fish)" ]
then
  command mkdir -p $conf/fish/conf.d/functions $conf/fish/conf.d/completions
  command ln -v $repo/agnostic/fish/conf.d/functions/*.sh $conf/fish/conf.d/functions/
  for i in 'fish' 'fish/conf.d/functions' 'fish/conf.d/completions'
  do
    [ -d $repo/$uname/$i ] && ( command ln -v $repo/$uname/$i/*.fish $conf/fish/$i/ )
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

[ -z "$TMUX" ] && [ -n "$(builtin command -v tmux)" ] && builtin printf 'exec tmux -2u -f %/conf' $tmux | command tee -a ~/.profile || [ -n "$(builtin command -v fish)" ] && builtin printf 'builtin exec %s' $(builtin command -v fish) | command tee -a ~/.profile || builtin printf 'builtin source %s/bash/config.sh' ${HOME} | command tee -a ~/.profile

builtin unset perms uname repo conf tmux

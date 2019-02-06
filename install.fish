if builtin test -z "$conf" -o ! -d "conf" -o ! -r "$conf" -o ! -w "$conf"
  builtin printf 'Please specify a read/writeable working directory.\n'
  builtin return 1
else
  builtin set conf $argv[1]
end

if builtin test (command uname -o) = Cygwin
  builtin set uname cygwin
  builtin set perms (net sessions >/dev/null 2>&1)
else
  builtin set uname ubuntu
  builtin set perms (sudo -nv ^/dev/null)
end

builtin set -l repo (realpath (command dirname (builtin status filename)))
command ln -v $repo/tmux.conf $conf/tmux.conf
command mkdir -p $conf/fish/functions $conf/fish/conf.d $conf/bash $conf/bash/conf.d/functions

for i in tmux.conf
         fish/config.fish
  command ln -v $repo/$uname/$i $conf/$i
end

for i in fish
         fish/conf.d
         fish/functions
         fish/completions
  command ln -rv $repo/$uname/$i/*.fish $conf/$i/
end

for i in bash
         bash/conf.d
         bash/conf.d/functions
do
  command ln -rv $repo/$uname/$i/*.sh $conf/$i/
done

if builtin test $perms -eq 0
  command ln -v $repo/$uname/fish/fish.nanorc /usr/share/nano/fish.nanorc
  if builtin test $uname = cygwin
    command ln -v $repo/$uname/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  end
else
  command ln -v $repo/$uname/fish/fish.nanorc $conf/fish/fish.nanorc
  builtin printf 'include %s/fish/fish.nanorc' $conf | command tee -a ~/.nanorc
  if builtin test $uname = cygwin
    command ln -v $repo/$uname/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
  end
end

if builtin -z "$TMUX" -a (builtin command -v tmux)
then
  builtin printf 'exec tmux -2u -f %s/tmux.conf' $conf | tee -a ~/.profile
else
  if builtin test (builtin command -v fish)
    builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile
  else
    builtin printf 'source "%s/bash/config.sh"' $conf | tee -a ~/.profile
  end
end

set -e perms uname repo conf

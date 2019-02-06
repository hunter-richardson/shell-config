builtin test -z "$argv[1]" -o ! -d "$argv[1]" -o ! -r "$argv[1]" -o ! -w "$argv[1]";
  and builtin printf 'Please specify a read/writeable working directory.\n';
  and builtin return 1;
  or  builtin set conf $argv[1]

if builtin test (command uname -o) = Cygwin
  builtin set uname cygwin;
    and builtin set perms (net sessions >/dev/null 2>&1)
else
  builtin set uname ubuntu;
    and builtin set perms (sudo -nv ^/dev/null)
end

builtin set repo (builtin status filename)
builtin test -z "$repo";
  and builtin printf 'An error occured while attempting to determine the script directory.\n';
  and builtin set -e perms uname repo conf;
  and builtin return 1
while builtin test -f $repo -o -L $repo;
  builtin set repo (builtin test -L $repo;
                      and return (command readlink $repo))
                      or  return (command dirname $repo);
end

builtin test ! -f $repo/$uname/tmux.conf -o ! -d $repo/$uname/fish/conf.d/functions -o ! $repo/$uname/bash/conf.d/functions -o ! -f $repo/$uname/fish/fish.nanorc -o ( $uname = ubuntu -a ! -f $repo/$uname/fish/fish.lang );
  and builtin printf 'Please run the %s script in the shell-config local repository directory.\n' (builtin status filename);
  and set -e perms uname repo conf;
  and builtin return 1;

command mkdir -p $conf/fish/conf.d/functions $conf/fish/conf.d/completions $conf/bash/conf.d/functions
command ln -v $repo/$uname/tmux.conf $conf/tmux.conf

for i in fish
         fish/conf.d
         fish/conf.d/functions
         fish/conf.d/completions
  builtin test -d $repo/$uname/$i;
    and command ln -rv $repo/$uname/$i/*.fish $conf/$i/
end
builtin test $uname == cygwin; 
  and for i in fish-source-highlight
               plugin-await
               plugin-balias
        builtin test -d (command dirname $repo)/$i/functions;
          and command ln -rv (command dirname $repo)/$i/functions/*.fish $conf/conf.d/functions/
        end

for i in bash
         bash/conf.d
         bash/conf.d/functions
  builtin test -d $repo/$uname/$i;
    and command ln -rv $repo/$uname/$i/*.sh $conf/$i/
end

if builtin test $perms -eq 0
  command ln -v $repo/$uname/fish/fish.nanorc /usr/share/nano/fish.nanorc
  builtin test $uname = ubuntu;
    and command ln -v $repo/$uname/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
else
  command ln -v $repo/$uname/fish/fish.nanorc $conf/fish/fish.nanorc
  builtin printf 'include %s/fish/fish.nanorc' $conf | command tee -a ~/.nanorc
  builtin test $uname = ubuntu;
    and command ln -v $repo/$uname/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
end

builtin -z "$TMUX" -a (builtin command -v tmux);
  and builtin printf 'exec tmux -2u -f %s/tmux.conf' $conf | tee -a ~/.profile
  or  builtin test (builtin command -v fish);
      and builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile;
      or  builtin printf 'source "%s/bash/config.sh"' $conf | tee -a ~/.profile

set -e perms uname repo conf

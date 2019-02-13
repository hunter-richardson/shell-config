builtin test -z "$argv[1]" -o ! -d "$argv[1]" -o ! -r "$argv[1]" -o ! -w "$argv[1]";
  and builtin printf 'Please specify a read/writeable working directory.\n';
  and builtin return 1;
  or  builtin set conf $argv[1]

builtin set repo (command find ~ -type d -name shell-config)

if builtin test (command uname -o) = Cygwin
  builtin set uname cygwin;
    and builtin set perms (command id -G | command grep -qE '\<554\>')
else
  builtin set uname ubuntu;
    and builtin set perms (sudo -nv ^/dev/null)
end

builtin test ! -f $repo/$uname/tmux.conf -o ! -d $repo/$uname/fish/conf.d/functions -o ! $repo/$uname/bash/conf.d/functions -o ! -f $repo/$uname/fish/fish.nanorc -o ( $uname = ubuntu -a ! -f $repo/$uname/fish/fish.lang );
  and builtin printf 'Please run the %s script in the shell-config local repository directory.\n' (builtin status filename);
  and set -e perms uname repo conf;
  and builtin return 1;

command mkdir -p $conf/fish/conf.d/functions $conf/fish/conf.d/completions $conf/bash/conf.d/functions
command ln -v $repo/$uname/tmux.conf $conf/tmux.conf

for i in fish fish/conf.d fish/conf.d/functions fish/conf.d/completions
  builtin test -d $repo/$uname/$i;
    and command ln -v $repo/$uname/$i/*.fish $conf/$i/
end
if builtin test $uname == cygwin
  builtin test ! -d (command find ~ d -name fundle);
    and cd (command dirname $repo);
    and command git clone --verbose --depth 1 https://github.com/danhper/fundle ./fundle
    and cd -
  builtin test -d (command find ~ d -name fundle)/functions;
    and command ln -v (command find ~ d -name fundle)/functions/*.fish $conf/fish/conf.d/functions/
  builtin test -d (command find ~ d -name fundle)/completions;
    and command ln -v (command find ~ d -name fundle)/completions/*.fish $conf/fish/conf.d/completions/
  builtin test -d (command find ~ d -name fundle);
    and builtin source $conf/fish/conf.d/*/fundle.fish;
    and fundle install;
    and for i in (fundle list | command grep -v https://github.com)
          builtin test -d $conf/fish/fundle/$i/completions;
            and command chmod a+x $conf/fish/fundle/$i/completions/*
          builtin test -d $conf/fish/fundle/$i/functions;
            and command chmod a+x $conf/fish/fundle/$i/functions/*
        end
else
  sudo wget https://git.io/fundle -O /root/.config/fish/functions/fundle.fish
  sudo fish --command="source /root/.config/fish/functions/fundle.fish; fundle install"
  for i in (sudo fish --command="source /root/.config/fish/functions/fundle.fish; fundle list | command grep -v https://github.com")
    builtin test -d $conf/fish/fundle/$i/completions;
      and sudo chmod a+x $conf/fish/fundle/$i/completions/*;
      and sudo ln -v /root/.config/fish/fundle/$i/completions/* $conf/fish/conf.d/completions/
    builtin test -d $conf/fish/fundle/$i/functions;
      and sudo chmod a+x $conf/fish/fundle/$i/functions/*;
      and sudo ln -v /root/.config/fish/fundle/$i/functions/* $conf/fish/conf.d/functions/
  end
end

for i in bash bash/conf.d bash/conf.d/functions
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

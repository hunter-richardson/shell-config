builtin test -z "$argv[1]" -o ! -d "$argv[1]" -o ! -r "$argv[1]" -o ! -w "$argv[1]";
  and builtin printf 'Please specify a read/writeable working directory.\n';
  and builtin exit 1;
  or  builtin set conf $argv[1]

builtin set repo (command find ~ -type d -name shell-config)

if builtin test (command uname -o) = Cygwin
  builtin set uname cygwin;
    and builtin set perms (command id -G | command grep -qE '\<554\>')
else
  builtin set uname ubuntu;
    and builtin set perms (sudo -nv ^/dev/null)
end

for i in cygwin/git/repos.git cygwin/git/config $uname/tmux/tmux.conf $uname/fish/fish.nanorc $uname/fish/fish.lang
  builtin test ! -f $repo/$i;
    and builtin printf 'Please run the %s script in the shell-config local repository directory.\n' (builtin status filename);
    and builtin set -e perms uname repo conf;
    and exit 1
end
for i in agnostic/fish/conf.d/functions agnostic/bash/conf.d/functions $uname/fish/conf.d/functions $uname/bash/conf.d/functions
  builtin test ! -d $i;
    and builtin printf 'Please run the %s script in the shell-config local repository directory.\n' (builtin status filename);
    and builtin set -e perms uname repo conf;
    and exit 1
end

builtin set tmux (builtin test $perms;
                    and builtin printf '%s' ${HOME};
                    or  builtin printf '/etc')/tmux
command mkdir -p $conf/fish/conf.d/functions $conf/fish/conf.d/completions $conf/bash/conf.d/functions $tmux;
  and command git clone --verbose --depth 1 https://github.com/tmux-plugins/tpm $tmux/tmux/tpm;
  and command ln -v $repo/$uname/tmux/conf $tmux/tmux/

builtin test $uname = cygwin;
  and command ln -v $repo/cygwin/git/config $conf/git/config
  and for i in (command cat $repo/cygwin/git/repos.git | command shuf)
        builtin printf '%s\n' $i;
          and command git clone --verbose --depth 1 $i $(command dirname $repo)/$(builtin printf '%s' $i | command grep -oE [^//]+$ | command cut -d'.' -f1)
      end

command ln -v $repo/agnostic/fish/conf.d/functions/*.fish $conf/fish/conf.d/functions/
for i in fish fish/conf.d fish/conf.d/functions fish/conf.d/completions
  builtin test -d $repo/$uname/$i;
    and command ln -v $repo/$uname/$i/*.fish $conf/fish/$i/
end
if builtin test $uname == cygwin
  for i in functions completions
    command wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O $conf/fish/conf.d/$i/fundle.fish;
      and command chmod -c a+x $conf/fish/conf.d/$i/fundle.fish
  end
  fish --command="source $conf/fish/config.fish"
else
  for i in functions completions
    sudo wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /root/.config/fish/conf.d/$i/fundle.fish;
      and sudo chmod -c o+x /root/.config/fish/conf.d/$i/fundle.fish
  end
  sudo fish --command="source /root/.config/fish/config.fish"
end

command ln -v $repo/agnostic/bash/conf.d/functions/*.sh $conf/bash/conf.d/functions/
for i in bash bash/conf.d bash/conf.d/functions
  builtin test -d $repo/$uname/$i;
    and command ln -v $repo/$uname/$i/*.sh $conf/$i/
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
  and builtin printf 'exec tmux -2u -f %s/tmux/conf' $tmux | tee -a ~/.profile;
  or  builtin test (builtin command -v fish);
      and builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile;
      or  builtin printf 'source "%s/bash/config.sh"' (builtin test $perms;
                                                         and builtin printf '${HOME}';
                                                         or  builtin printf '/etc')/bash/config.sh | tee -a ~/.profile

builtin set -e perms uname repo conf tmux

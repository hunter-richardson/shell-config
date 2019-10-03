builtin test -z "$argv[1]" -o ! -d "$argv[1]" -o ! -r "$argv[1]" -o ! -w "$argv[1]";
  and builtin printf 'Please specify an existing read/writeable working directory.\n';
  and builtin exit 1;
  or  builtin set conf $argv[1]

builtin set repo (command find ~ -type d -name shell-config)

if builtin test (command uname -o) = Cygwin
  builtin set uname cygwin;
    and builtin set perms (builtin test (command id -G | command grep -qE '\<554\>');
                             and builtin printf 'global';
                             or  builtin printf 'user')
else
  builtin set uname ubuntu;
    and builtin set perms (builtin test (sudo -nv ^/dev/null);
                             and builtin printf 'global';
                             or  builtin printf 'user')
end

builtin set tmux (builtin test $perms = 'global';
                    and builtin printf '%s' ${HOME};
                    or  builtin printf '/etc')/tmux
command mkdir -p $conf/fish/conf.d/functions $conf/fish/conf.d/completions $conf/bash/conf.d/functions $tmux;
  and command git clone --verbose --depth 1 https://github.com/tmux-plugins/tpm $tmux/tmux/tpm;
  and command ln -v $repo/$perms/tmux/conf $tmux/tmux/

builtin command -v cheat;
  and command wget -v https://raw.githubusercontent.com/cheat/cheat/master/cheat/autocompletions/cheat.fish -O $conf/fish/conf.d/completions/cheat.fish

builtin test $uname = cygwin;
  and command ln -v $repo/cygwin/git/config $conf/git/config;
  and for i in (command grep -Ev '^#' $repo/cygwin/git/repos.git | command shuf)
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
  end
  builtin source $conf/fish/conf.d/*/fundle.fish
  for i in (builtin set -g | command cut -d' ' -f1 | command grep -E '^__fundle.*_plugin')
    builtin set -e $i
  end
  for i in (command grep -Ev '^#' $conf/fish/fundle.plugins)
    builtin printf 'load plugin %s\n' $i | builtin string replace / :
    fundle plugin $i
  end
  fundle install;
    and fundle init
  end
else
  for i in functions completions
    wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /root/.config/fish/conf.d/$i/fundle.fish;
  end
  ln -v $repo/ubuntu/fish/fundle.plugins /root/.config/fish/
  builtin source /root/.config/fish/conf.d/*/fundle.fish
  for i in (command set -g | command cut -d' ' -f1 | command grep -E '^__fundle.*_plugin')
    builtin set -e $i
  end
  for i in (command grep -Ev '^#' /root/.config/fish/fundle.plugins)
    builtin printf 'load plugin %s\n' $i | builtin string replace / :
    fundle plugin $i
  end
  fundle install;
    and fundle init
  for i in (command ls -1 /root/.config/fish/fundle/**/{completions,functions}/*.fish)
    command ln -v $i /etc/fish/conf.d/(basename (dirname $i))/
  end
end

command ln -v $repo/agnostic/bash/conf.d/functions/*.sh $conf/bash/conf.d/functions/
for i in bash bash/conf.d bash/conf.d/functions
  builtin test -d $repo/$uname/$i;
    and command ln -v $repo/$uname/$i/*.sh $conf/$i/
end

if builtin test $perms = 'global'
  sudo ln -v $repo/agnostic/fish/fish.nanorc /usr/share/nano/fish.nanorc
  sudo ln -v $repo/agnostic/fish/fish.lang /usr/local/share/source-highlight
  builtin test $uname = ubuntu;
    and sudo ln -v $repo/agnostic/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
else
  command mkdir -p ${HOME}/.local/cellar/share/source-highlight
  command ln -v $repo/agnostic/fish/fish.nanorc $conf/fish/fish.nanorc
  builtin printf 'include %s/fish/fish.nanorc' $conf | command tee -a ~/.nanorc
  command ln -v $repo/agnostic/fish/fish.lang ${HOME}/.local/share/source-highlight
  builtin test $uname = ubuntu;
    and command ln -v $repo/agnostic/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
end

builtin -z "$TMUX" -a (builtin command -v tmux);
  and builtin printf 'exec tmux -2u -f %s/tmux/conf' $tmux | tee -a ~/.profile;
  or  builtin test (builtin command -v fish);
      and builtin printf 'exec %s' $(builtin command -v fish) | tee -a ~/.profile;
      or  builtin printf 'source "%s/bash/config.sh"' (builtin test $perms;
                                                         and builtin printf '${HOME}';
                                                         or  builtin printf '/etc')/bash/config.sh | tee -a ~/.profile

builtin set -e perms
builtin set -e uname
builtin set -e repo
builtin set -e conf
builtin set -e tmux

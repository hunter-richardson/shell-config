if builtin test -z "$argv[1]" -o ! -r "$argv[1]" -o ! -w "$argv[1]"
  builtin printf 'Please specify a read/writeable working directory.\n'
  builtin return 1
end

builtin set uname -l (command uname -a | command awk 'NF>1{print $NF}')

builtin test $uname = Cygwin;
  and builtin set -l perms (command net sessions >/dev/null 2>&1);
  or  builtin set -l perms (command sudo -nv ^/dev/null)

command ln -v (command pwd)/tmux.conf $argv[1]/tmux.conf
command mkdir -p $argv[1]/fish/functions $argv[1]/fish/conf.d $argv[1]/bash

for i in bash
         fish
         fish/conf.d
         fish/functions
  command ln -rv (command pwd)/$i/* $argv[1]/$i/
end

if builtin test $perms -eq 0
  builtin set -l profile /etc/bash.bashrc
  command ln -v $(command pwd)/fish/fish.nanorc /usr/share/nano/fish.nanorc
  builtin test $uname = Cygwin;
    or command ln -v $(command pwd)/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  end
else
  builtin set -l profile ~/.bash_profile
  builtin printf 'include %s/.config/fish/fish.nanorc' $HOME | tee -a ~/.nanorc
  builtin test $uname = Cygwin;
    or command ln -v $(command pwd)/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
end

builtin printf 'if [ -f "/etc/bash/.profile" ]\nthen\n  source "/etc/bash/.profile"\nfi' | tee -a $profile
builtin printf 'if [ -f "${HOME}/.config/bash/.profile" ]\nthen\n  source "${HOME}/.config/bash/.profile"\nfi' | tee -a $profile

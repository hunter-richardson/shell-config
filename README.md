# shell-config [![CodeFactor](https://www.codefactor.io/repository/github/hunter-richardson/shell-config/badge)](https://www.codefactor.io/repository/github/hunter-richardson/shell-config)
This is the repository for my shell configuration. I use [Ubuntu](https://ubuntu.com) at home and [Cygwin](https://cygwin.com) at work.
- Before configuring the shell in [Cygwin](https://cygwin.com), first pull down a few `git` repositories. [repos.git](cygwin/git/repos.git) lists the repos I use for [Cygwin](https://cygwin.com).
```bash
su - # if applicable
if [ $(uname -o) == 'Cygwin' ]
  ln -v /path/to/repo/cygwin/git/config /path/to/new/config/git/
  for i in $(grep -Ev '^#' /path/to/repo/cygwin/git/repos.git)
  do
    printf '%s -> %s' $i $(dirname /path/to/repo)/$(echo $i | grep -oE '[^//]+$' | cut -d'.' -f1)
        && git clone --verbose --depth 1 $i $(dirname /path/to/repo)/$(echo $i | grep -oE '[^//]+$' | cut -d'.' -f1)
  done
fi
```
- [Ubuntu](https://ubuntu.com) and [Cygwin](https://cygwin.com) both ship with `bash` as the default shell. My favorite shell is [Fish](https://fishshell.com). I've written a few functions and aliases that are helpful for my shell in [cygwin:fish](cygwin/fish)/[ubuntu:fish](ubuntu/fish) and their subdirectories. [agnostic:fish](agnostic/fish/conf.d/functions) contains functions that work under either Linux system. To apply them:
```bash
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  [ $(uname -o) == 'Cygwin' ]
        && uname='cygwin'
        || uname='ubuntu'
  mkdir -p /path/to/new/config/fish/conf.d/functions
           /path/to/new/config/fish/conf.d/completions
  ln -v /path/to/repo/agnostic/fish/conf.d/functions/*.fish /path/to/new/config/fish/conf.d/functions/
  for i in 'fish'
           'fish/conf.d'
           'fish/conf.d/functions'
           'fish/conf.d/completions'
  do
    [ -d /path/to/repo/$uname/$i ]
        && ln -v /path/to/repo/$uname/$i/*.fish /path/to/new/config/$i/
  done
fi
```
- I will use [`fundle`](https://github.com/danhper/fundle) to install several `fish` plugins, listed in [cygwin:plugins.fish](cygwin/fish/plugins.fish) / [ubuntu:plugins.fish](ubuntu/fish/plugins.fish). To apply them:
```bash
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  if [ $(uname -o) == 'Cygwin' ]
  then
    for i in 'functions'
             'completions'
    do
      wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /path/to/new/config/conf.d/$i/fundle.fish
          && chmod -c a+x /path/to/new/config/fish/conf.d/$i/fundle.fish
    done
    fish --command="source /path/to/new/config/fish/conf.d/*/fundle.fish
                    for i in (set -g | cut -d' ' -f1 | grep -E '^__fundle.*_plugin')
                      set -e $i
                    end
                    for i in (grep -Ev '^#' /path/to/repo/cygwin/fish/fundle.plugins)
                      printf 'load plugin %s\n' $i | string replace / :
                      fundle plugin $i
                    end
                    fundle install;
                      and fundle init
                    for i in (ls -1 ~/.config/fish/fundle/**.fish)
                      chmod a+x $i
                      source $i
                    end
                    exit"
  else
    for i in 'functions'
             'completions'
    do
      wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /root/.config/conf.d/$i/fundle.fish
          && chmod -c o+x /root/.config/fish/conf.d/$i/fundle.fish
    done
    ln -v /path/to/repo/ubuntu/fish/fundle.plugins /root/.config/
    fish --command="source /path/to/new/config/fish/conf.d/*/fundle.fish
                    for i in (set -g | cut -d' ' -f1 | grep -E '^__fundle.*_plugin')
                      set -e $i
                    end
                    for i in (grep -Ev '^#' /root/.config/fish/fundle.plugins)
                      printf 'load plugin %s\n' $i | string replace / :
                      fundle plugin $i
                    end
                    fundle install;
                      and fundle init
                    for i in (ls -1 /root/.config/fish/fundle/**.fish)
                      chmod a+x $i
                      ln -v $i /etc/fish/conf.d/(basename (dirname $i))/
                    end
                    exit"
fi
 
fi
```
- The [agnostic:fish.lang](agnostic/fish/fish.lang) and [agnostic:fish.nanorc](agnostic/fish/fish.nanorc) files contain configuration for syntax-highlighting of Fish scripts, in [source-highlight](https://gnu.org/software/src-highlight), 
[`gedit`](https://wiki.gnome.org/Apps/Gedit), and [`nano`](https://nano-editor.org). To apply them:
```bash
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  [ $(uname -o) == 'Cygwin' ]
        && uname='cygwin'
        || uname='ubuntu'
  [ uname == 'cygwin' ] && [ $(id -G | grep -qE '\<554\>') ]
        && perms='global' || perms='user'
  [ uname == 'ubuntu' ] && [ $(sudo -nv ^/dev/null) ]
        && perms='global' || perms='user'
  if [ $perms == 'global' ]
  then
    sudo ln -v /path/to/repo/agnostic/fish/fish.nanorc /usr/share/nano/fish.nanorc
    sudo ln -v /path/to/repo/agnostic/fish/fish.lang /usr/share/source-highlight/
    [ $uname == 'ubuntu' ]
          && sudo ln -v /path/to/repo/agnostic/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/
  else
    mkdir -p ${HOME}/.local/share/source-highlight
    ln -v /path/to/repo/agnostic/fish/fish.nanorc /path/to/new/config/fish/fish.nanorc
    printf 'include %s/fish/fish.nanorc' /path/to/new/config | tee -a ~/.nanorc
    ln -v /path/to/repo/agnostic/fish/fish.lang ${HOME}/.local/share-highlight/
    [ $uname == 'ubuntu' ]
          && ln -v /path/to/repo/agnostic/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/
  fi
fi
```
- `tmux` is a terminal multiplexer that sets up a status bar and allows windows to split into panes. The [global:tmux/conf](global/tmux/conf) / [user:tmux/conf](user/tmux/conf) files contain my global and user `tmux` configurations, respectively. See the [tmux manual](https://man.openbsd.org/OpenBSD-current/man1/tmux.1) for more information. To apply it:
```bash
su - # if applicable
[ $(uname -o) == 'Cygwin' ]
      && uname='cygwin'
      || uname='ubuntu'
[ uname == 'cygwin' ]
      && [ $(id -G | grep -qE '\<554\>') ] && perms='global' || perms='user'
      || [ $(sudo -nv ^/dev/null) ] && perms='global' || perms='user'
[ $perms == 'global' ]
      && tmux="/etc/tmux"
      || tmux="${HOME}/tmux"
mkdir -p $tmux
    && git clone --verbose --depth 1 https://github.com/tmux-plugins/tpm $tmux/tpm
    && ln -v /path/to/repo/$perms/tmux/conf $tmux/
```
- [`cheat`](https://github.com/cheat/cheat) is a utility that generates common usages of well-known but confusing Unix commands (e.g. `tar`). I installed this onto [Ubuntu](https://ubuntu.com); unfortunately for [Cygwin](https://cygwin.com), I cannot install it due to dependencies. A `fish` completions file is available in the git repo, but not in the [`Snap`](https://snapcraft.io) store. To apply it:
```bash
su - # if applicable
[ -n "$(command -v cheat)" ] || wget -v https://raw.githubusercontent.com/cheat/cheat/master/cheat/autocompletion/cheat/fish -O /path/to/new/config/fish/conf.d/completions/cheat.fish
```
- Some installations of [Cygwin](https://cygwin.com) (probably managed by snarky old-timers) don't include new-and-fancy custom shells like [Fish](https://fishshell.com) -- in which case I must resort to `bash` instead. To this end, I have translated my `fish` functions and aliases into `bash`. To apply them:
```bash
su - # if applicable
[ $(uname -o) == 'Cygwin' ]
      && uname='cygwin'
      || uname='ubuntu'
mkdir -p /path/to/new/config/bash/conf.d/functions
ln -v /path/to/repo/agnostic/bash/conf.d/functions/*.sh /path/to/new/config/bash/conf.d/functions/
for i in 'bash'
         'bash/conf.d'
         'bash/conf.d/functions'
do
  [ -d /path/to/repo/$uname/$i ]
        && ln -v /path/to/repo/$uname/$i/*.sh /path/to/new/config/$i/
done
```
- To use [Fish](https://fishshell.com) and its configuration described here by default without going through the whole `cshs` trouble, or to use the `bash` functions described, run a command at the bottom of the `~/.profile` file to open a `tmux` session into `fish`. (Make sure both `tmux` and `fish` work before using this!) To apply it:
```bash
su - # if applicable
[ uname == 'cygwin' ]
      && [ $(id -G | grep -qE '\<554\>') ] && perms='global' || perms='user'
      || [ $(sudo -nv ^/dev/null) ] && perms='global' || perms='user'
[ $perms -eq 0 ]
      && tmux="/etc/tmux"
      || tmux="${HOME}/tmux"
[ -z "$TMUX" ] && [ -n "$(command -v tmux)" ]
    && printf 'exec tmux -2u -f %/conf' $tmux | tee -a ~/.profile
    || [ -n "$(command -v fish)" ]
           && printf 'exec %s' $(command -v fish) | tee -a ~/.profile
           || printf 'source %s/bash/config.sh' ${HOME} | tee -a ~/.profile
```
- Except for the fundle configuration, quick application of this shell can be attained by executing the [install.sh](install.sh) script. It assumes admin privileges are used if a system-wide configuration is desired, and the script has not been moved to another directory. (And, for the sake of completeness, I have translated the script into `fish` as well:  [install.fish](install.fish).)
```bash
su - # if applicable
source /path/to/repo/install.sh /path/to/new/config
```

# shell-config [![CodeFactor](https://www.codefactor.io/repository/github/hunter-richardson/shell-config/badge)](https://www.codefactor.io/repository/github/hunter-richardson/shell-config)
This is the repository for my shell configuration. I use [Ubuntu](https://ubuntu.com) at home and [Cygwin](https://cygwin.com) at work.
- Before configuring the shell in [Cygwin](https://cygwin.com), first pull down a few `git` repositories. [repos.git](cygwin/git/repos.git) lists the repos I use for [Cygwin](https://cygwin.com).
```bash
su - # if applicable
if [ $(uname -o) == 'Cygwin' ]
  ln -v /path/to/repo/cygwin/git/config /path/to/new/config/git/
  for i in $(cat /path/to/repo/cygwin/git/repos.git)
  do
    printf '%s -> %s' $i $(dirname /path/to/repo)/$(echo $i | grep -oE '[^//]+$' | cut -d'.' -f1)
        && git clone --verbose --depth 1 $i $(dirname /path/to/repo)/$(echo $i | grep -oE '[^//]+$' | cut -d'.' -f1)
  done
fi
```
- [Ubuntu](https://ubuntu.com) and [Cygwin](https://cygwin.com) both ship with `bash` as the default shell. My favorite shell is [Fish](https://fishshell.com). I've written a few functions and aliases that are helpful for my shell in 
[cygwin:fish](cygwin/fish)/[ubuntu:fish](ubuntu/fish) and their subdirectories. Additionally for [Cygwin](https://cygwin.com), I will use [`fundle`](https://github.com/danhper/fundle) to install several `fish` plugins, listed in 
[cygwin:config.fish](cygwin/fish/config.fish). (For [Ubuntu](https://ubuntu.com), I use [system-wide `fundle` configuration](https://github.com/hunter-richardson/my-config/blob/master/root/.config/fish/config.fish) to accomplish this.) To apply them:
```bash
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  [ $(uname -o) == 'Cygwin' ]
        && uname='cygwin'
        || uname='ubuntu'
  mkdir -p /path/to/new/config/fish/conf.d/functions /path/to/new/config/fish/conf.d/completions
  ln -v /path/to/repo/agnostic/fish/conf.d/functions/*.fish /path/to/new/config/fish/conf.d/functions/
  for i in 'fish'
           'fish/conf.d'
           'fish/conf.d/functions'
           'fish/conf.d/completions'
  do
    [ -d /path/to/repo/$uname/$i ]
        && ln -v /path/to/repo/$uname/$i/*.fish /path/to/new/config/$i/
  done
  if [ $uname == 'cygwin' ]
  then
    for i in 'functions'
             'completions'
    do
      wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /path/to/new/config/conf.d/$i/fundle.fish
          && chmod -c a+x /path/to/new/config/fish/conf.d/$i/fundle.fish
    done
    fish --command="source /path/to/new/config/fish/config.fish"
  else
    for i in 'functions'
             'completions'
    do
      sudo wget -v https://raw.githubusercontent.com/danhper/fundle/master/$i/fundle.fish -O /root/.config/conf.d/$i/fundle.fish
          && chmod -c o+x /root/.config/fish/conf.d/$i/fundle.fish
    done
    sudo fish --command="source /root/.config/config.fish"
  fi
fi
```
- The [ubuntu:fish.lang](ubuntu/fish/fish.lang) and [ubuntu:fish.nanorc](ubuntu/fish/fish.nanorc) / [cygwin:fish.nanorc](cygwin/fish/fish.nanorc) files contain configuration for syntax-highlighting of Fish scripts, in `gedit` ([Ubuntu](https://ubuntu.com) only) and `nano`, respectively. To apply them:
```bash
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  [ $(uname -o) == 'Cygwin' ]
        && uname='cygwin'
        || uname='ubuntu'
  [ uname == 'cygwin' ]
        && perms=$(id -G | grep -qE '\<554\>')
        || perms=$(sudo -nv ^/dev/null)
  if [ $perms -eq 0 ]
  then
    ln -v /path/to/repo/$uname/fish/fish.nanorc /usr/share/nano/fish.nanorc
    [ $uname == 'ubuntu' ]
          && sudo ln -v /path/to/repo/ubuntu/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang
  else
    ln -v /path/to/repo/$uname/fish/fish.nanorc /path/to/new/config/fish/fish.nanorc
    printf 'include %s/fish/fish.nanorc' /path/to/new/config | tee -a ~/.nanorc
    [ $uname == 'ubuntu' ]
          && ln -v /path/to/repo/ubuntu/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang
  fi
fi
```
- `tmux` is a terminal multiplexer that sets up a status bar and allows windows to split into panes. The [ubuntu:tmux/conf](ubuntu/tmux/conf) / [cygwin:tmux/conf](cygwin/tmux/conf) files contain my `tmux` configuration. See the [tmux
manual](https://man.openbsd.org/OpenBSD-current/man1/tmux.1) for more information. To apply it:
```bash
su - # if applicable
[ $(uname -o) == 'Cygwin' ]
      && uname='cygwin'
      || uname='ubuntu'
[ uname == 'cygwin' ]
      && perms=$(id -G | grep -qE '\<554\>')
      || perms=$(sudo -nv ^/dev/null)
[ $perms -eq 0 ]
      && tmux="/etc/tmux"
      || tmux="${HOME}/tmux"
command mkdir -p $tmux
command git clone --verbose --depth 1 https://github.com/tmux-plugins/tmux $tmux/tpm
command ln -v /path/to/repo/$uname/tmux/conf $tmux/
```
- Some installations of [Cygwin](https://cygwin.com) (probably managed by snarky old-timers) don't include new-and-fancy custom shells like [Fish](https://fishshell.com) -- in which case I must resort to `bash` instead. To this end, I have
translated my `fish` functions and aliases into `bash`. To apply them:
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
[ -z "$TMUX" ] && [ -n "$(builtin command -v tmux)" ]
    && builtin printf 'exec tmux -2u -f %/conf' $tmux | command tee -a ~/.profile
    || [ -n "$(builtin command -v fish)" ]
           && builtin printf 'builtin exec %s' $(builtin command -v fish) | command tee -a ~/.profile
           || builtin printf 'builtin source %s/bash/config.sh' ${HOME} | command tee -a ~/.profile
```
- Quick application of this configuration can be attained by executing the [install.sh](install.sh) script. It assumes admin privileges are used if a system-wide configuration is desired, and the script has not been moved to another directory. (And,
for the sake of completeness, I have translated the script into `fish` as well:  [install.fish](install.fish).)
```bash
su - # if applicable
source /path/to/repo/install.sh /path/to/new/config
```

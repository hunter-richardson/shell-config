# shell-config
This is the repository for my shell configuration. I use [Ubuntu](https://ubuntu.com) at home and [Cygwin](https://cygwin.com) at work.
- [Ubuntu](https://ubuntu.com) and [Cygwin](https://cygwin.com) both ship with `bash` as the default shell. My favorite shell is [Fish](https://fishshell.com). I've written a few functions and aliases that are helpful for my shell in [cygwin:fish](cygwin/fish)/[ubuntu:fish](ubuntu/fish) and their subdirectories. Additionally for [Cygwin](https://cygwin.com), I will install several fish plugins using [fundle](https://github.com/danhper/fundle). (For [Ubuntu](https://ubuntu.com), I use a system-wide [fundle](https://github.com/danhper/fundle) configuration to accomplish this.) To apply them:
```shell
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  [ $(uname -o) == 'Cygwin' ]
        && ( uname='cygwin' )
        && ( uname='ubuntu' )
  mkdir -p /path/to/new/config/fish/conf.d/functions /path/to/new/config/fish/conf.d/completions
  for i in 'fish'
           'fish/conf.d'
           'fish/conf.d/functions'
           'fish/conf.d/completions'
  do
    ln -v /path/to/repo/$uname/fish/$i/*.fish /path/to/new/config/$i/
  done
  if [ $uname == 'cygwin' ]
  then
    [ -d $(command dirname $repo)/fundle/functions ]
          && ( command ln -v $(command dirname $repo)/fundle/functions/*.fish $conf/conf.d/functions/ )
    [ -d $(command dirname $repo)/fundle/completions ]
          && ( command ln -v $(command dirname $repo)/fundle/completions/*.fish $conf/conf.d/completions/ )
  fi
fi
```
- The [ubuntu:fish.lang](ubuntu/fish/fish.lang) and [ubuntu:fish.nanorc](ubuntu/fish/fish.nanorc) / [cygwin:fish.nanorc](cygwin/fish/fish.nanorc) files contain configuration for syntax-highlighting of Fish scripts, in `gedit` ([Ubuntu](https://ubuntu.com) only) and `nano`, respectively. To apply them:
```shell
if [ -n "$(command -v fish)" ]
then
  su - # if applicable
  [ $(uname -o) == 'Cygwin' ]
        && ( uname='cygwin' )
        && ( uname='ubuntu' )
  [ uname == 'cygwin' ]
        && ( perms=$(net sessions >/dev/null 2>&1) )
        && ( perms=$(sudo -nv ^/dev/null) )
  if [ $perms -eq 0 ]
  then
    ln -v /path/to/repo/$uname/fish/fish.nanorc /usr/share/nano/fish.nanorc
    [ $uname == 'ubuntu' ]
          && ( ln -v /path/to/repo/ubuntu/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang )
  else
    ln -v /path/to/repo/$uname/fish/fish.nanorc /path/to/new/config/fish/fish.nanorc
    printf 'include %s/fish/fish.nanorc' /path/to/new/config | tee -a ~/.nanorc
    [ $uname == 'ubuntu' ]
          && ( ln -v /path/to/repo/ubuntu/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang )
  fi
fi
```
- `tmux` is a terminal multiplexer that sets up a status bar and allows windows to split into panes. The [ubuntu:tmux.conf](ubuntu/tmux.conf) / [cygwin:tmux.conf](cygwin/tmux.conf) files contain my `tmux` configuration. See the [tmux
manual](https://man.openbsd.org/OpenBSD-current/man1/tmux.1) for more information. To apply it:
```shell
su - # if applicable
[ $(uname -o) == 'Cygwin' ]
      && ( uname='cygwin' )
      && ( uname='ubuntu' )
ln -v /path/to/repo/$uname/tmux.conf /path/to/new/config/tmux.conf
```
- Some installations of [Cygwin](https://cygwin.com) (probably managed by snarky old-timers) don't include new-and-fancy custom shells like [Fish](https://fishshell.com) -- in which case I must resort to `bash` instead. To this end, I have
translated my `fish` functions and aliases into `bash`. To apply them:
```shell
su - # if applicable
[ $(uname -o) == 'Cygwin' ]
      && ( uname='cygwin' )
      && ( uname='ubuntu' )
mkdir -p /path/to/new/config/bash/conf.d/functions
for i in 'bash'
         'bash/conf.d'
         'bash/conf.d/functions'
do
  ln -v /path/to/repo/$uname/$i/*.sh /path/to/new/config/$i/
done
```
- To use [Fish](https://fishshell.com) and its configuration described here by default without going through the whole `cshs` trouble, or to use the `bash` functions described, run a command at the bottom of the `~/.profile` file to open a `tmux` session into `fish`. (Make sure both `tmux` and `fish` work before using this!) To apply it:
```shell
su - # if applicable
[ -z "$TMUX" -a -n "$(command -v tmux)" ]
      && ( printf 'exec tmux -2u -f %s/tmux.conf' /path/to/new/config | tee -a ~/.profile )
      || ( [ -n "$(command -v fish)" ]
                && ( printf 'exec %s' $(command -v fish) | tee -a ~/.profile )
                || ( printf 'source "%s/bash/config.sh"' /path/to/new/config | tee -a ~/.profile ) )
```
- Quick application of this configuration can be attained by executing the [install.sh](install.sh) script. It assumes admin privileges are used if a system-wide configuration is desired, and the script has not been moved to another directory. (And,
for the sake of completeness, I have translated the script into `fish` as well:  [install.fish](install.fish).)
```shell
su - # if applicable
source /path/to/repo/install.sh /path/to/new/config
```

# my-config
This is the repository for my shell configuration.
- [Ubuntu](https://ubuntu.com)/[Cygwin](https://cygwin.com) ships with `bash` as its default shell. My favorite shell is [Fish](https://fishshell.com), using [`fundle`](https://github.com/tuvistavie/fundle) to load some useful plugins, where possible.
I've written a few functions and aliases that are helpful for my shell in [fish](fish) and its subdirectories. To apply them:
```shell
su - # if applicable
uname=$(uname -a | awk 'NF>1{print $NF}')
[ $uname == "Cygwin" ] && ( perms=$(net sessions >/dev/null 2>&1) ) || ( perms=$(sudo -nv ^/dev/null) )
[ $perms -eq 0 ] && ( conf="/etc" ) || ( conf="${HOME}/.config" )
mkdir -p $conf/fish/functions $conf/fish/conf.d
for i in "fish"
         "fish/conf.d"
         "fish/functions"
do
  ln -rv /path/to/repo/fish/$i/* $conf/$i/
done
```
- The [fish.lang](fish/language-specs/fish.lang) and [fish.nanorc](fish/fish.nanorc) files contain configuration for syntax-highlighting of Fish scripts, in `gedit` and `nano`, respectively. To apply them:
```shell
if [ $perms -eq 0 ]
then
  ln -v /path/to/repo/fish/fish.nanorc /usr/share/nano/fish.nanorc
  [ $uname != "Cygwin" ] && ( ln -v /path/to/repo/fish/fish.lang /usr/share/gtksourceview-3.0/language-specs/fish.lang )
else
  ln -v /path/to/repo/fish/fish.nanorc ${HOME}/.config/fish/fish.nanorc
  [ $uname != "Cygwin" ] && ( ln -v /path/to/repo/fish/fish.lang ${HOME}/.local/share/gtksourceview-3.0/language-specs/fish.lang )
fi
```
- `tmux` is a terminal multiplexer that sets up a status bar and allows windows to split into panes. The [tmux.conf](tmux.conf) file contains my tmux configuration. See the [tmux manual](https://man.openbsd.org/OpenBSD-current/man1/tmux.1) for more
information. To apply it:
```shell
ln -v /path/to/repo/tmux.conf $conf/tmux.conf
```
- To use [Fish](https://fishshell.com) by default wihtout going through the whole `cshs` trouble, I put a script at the bottom of the [.profile](bash/.profile) file which opens a `tmux` session into `fish`. (Make sure both `tmux` and `fish` work
before using this!) To apply it:
```shell
ln -fv /path/to/repo/bash/.profile $conf/bash/.profile
```
Then modify `~/.bash_profile` to reference it.
```shell
[ -f "/etc/bash/.profile" ] && ( source "/etc/bash/.profile" )
[ -f "${HOME}/.config/bash/.profile" ] && ( source "${HOME}/.config/bash/.profile" )
```
- However, some installations of [Cygwin](https://cygwin.com) (probably managed by snarky old-timers) don't include new-and-fancy custom shells like [Fish](https://fishshell.com) -- in which case I must resort to `bash` instead. To this end, I have
translated my `fish` functions and aliases into `bash`. To apply them:
```shell
ln -v /path/to/repo/bash/*.sh $conf/bash/
```
And [.profile](bash/.profile) from earlier will pick them up.
- Quick application of this configuration can be attained by executing the [install.sh](install.sh) script. It assumes admin privileges are used if a system-wide configuration is desired, and the current-working directory is the location of this
repository. (And, for the sake of completeness, I have translated this into `fish` as well:  [install.fish](install.fish).)
```shell
cd /path/to/repo
source ./install.sh $conf
cd -
```
... where `$conf` is the location of the desired configuration.

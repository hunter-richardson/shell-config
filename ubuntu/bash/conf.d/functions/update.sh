#!/bin/bash

function update {
  function __update_apt {
    if [[ $@ =~ *--quiet* ]]
    then
      sudo apt-fast -qq update && sudo apt-fast -qq autoremove -y && sudo apt-fast -qq upgrade -y && sudo apt-fast -qq install -fy && sudo apt-fast -qq clean -y
    else
      sudo apt-fast update && sudo apt-fast autoremove -y && sudo apt-fast upgrade -y && sudo apt-fast install -fy && sudo apt-fast -y
    fi
  }

  function __update_brew {
    if [[ $@ =~ *--quiet* ]]
    then
      command brew update -q && command brew cleanup -q
      [ -n $(command brew outdated -v) ] && command brew upgrade -q
    else
      command brew update -v && command brew cleanup -v
      [ -n $(command brew outdated -v) ] && command brew upgrade -v
    fi
  }

  function __update_gem {
    if [[ $@ =~ *--quiet* ]]
    then
      sudo gem cleanup --quiet
      sudo gem update $(command gem outdated | command cut -d' ' -f1 | command xargs) --quiet
      [ -n "$(command gem list | grep rubygems-update)" ] && sudo update_rubygems --quiet
    else
      sudo gem cleanup --verbose
      for i in $(command gem outdated | command cut -d' ' -f1)
      do
        command gem info $i -ae && sudo gem update $i --verbose
      end
      [ -n "$(command gem list | grep rubygems-update)" ] && sudo update_rubygems --verbose
    fi
  }

  function __update_git {
    sudo updatedb
    for i in $(sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
    do
      current=$(command git -C $i rev-parse --short HEAD)
      url=$(command git -C $i config --get remote.origin.url)
      builtin printf 'Updating %s ...\n' $url
      [[ $@ != *"--quiet"* ]] && [ ! $(command git -C $(command dirname $i) diff-index --quiet HEAD) ] && builtin printf '%sLocal Changes:%s\n' $(format red) $(format normal) && builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain) && sudo git -C $(command dirname $i) pull --verbose || sudo git -C $(command dirname $i) pull
      if [ $current != $(command git -C $i rev-parse --short HEAD) ]
      then
        [[ $i =~ */hunter-richardson/shell-config/.git ] && builtin source /etc/bash/config.sh && command tmux source /etc/tmux/conf || [[ $i =~ */tmux-plugins/tpm/.git ]] && command tmux source /etc/tmux/conf
      fi
      builtin unset current url
    done
  }

  function __update_snap {
    for i in $(sudo snap list | command sed -n '1!p' | command cut -d' ' -f1 | command shuf)
    do
      [[ $@ =~ *--quiet* ]] && command snap info --verbose $i || builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2)
      sudo snap refresh $i
    done
  }

  [ ! $(command members sudo | command grep $(command whoami)) -a ! $(command members root | command grep $(command whoami)) ] && builtin printf "You are not a sudoer!" && return 121
  [ $(command nmcli networking connectivity check) != 'full' ] && builtin printf 'Unable to open an Internet connection' && return 0
  [[ $@ =~ *--quiet* ]] && quiet='--quiet' || quiet=''
  [ $# -eq 0 ] && SPMs='all' || SPMs=$(builtin printf "%s\n" $@ | command grep -E '^all|apt|brew|bundle|git|snap$')
  if [[ $SPMs =~ all ]]
  then
    for i in 'apt' 'brew' 'bundle' 'git' 'snap'
    do
      builtin eval __update_$i $quiet
    done
  else
    for i in 'apt' 'brew' 'bundle' 'git' 'snap'
    do
      [[ $SPMs =~ $i ]] && builtin eval __update_$i $quiet
    done
  fi

  builtin unset quiet
  builtin unset -f __update_apt __update_git __update_pip __update_raw __update_snap
}

#!/bin/bash

function update() {
  function __update_apt() {
    sudo apt-fast update && sudo apt-fast autoremove -y && sudo apt-fast upgrade -y && sudo apt-fast install -fy && sudo apt-fast clean -y
  }

  function __update_git() {
    sudo updatedb
    for i in $(sudo locate -eiq '/.git' | grep -v '/.config/' | command shuf)
    do
      sudo git -C $i pull --verbose
    done
    unset gits
  }

  function __update_pip() {
    for i in $(command sudo pip3 list --format=freeze | cut -d= -f1 | command shuf)
    do
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2) && sudo pip3 install $i -U -vvv
    done
  }

  function __update_raw() {
    sudo updatedb
    for i in $(command cat $(sudo locate -eiq '/my-config/dpkg.raw') | command shuf)
    do
      filename=$(buildin printf '%s' $i | command grep -oE '[^//]+$') && sudo srm -lvz /usr/local/bin/$filename && sudo curl -v -o /usr/local/bin/$filename $i && sudo chmod +x /usr/local/bin/$filename
    done
  }

  function __update_snap() {
    for i in $(command sudo snap list | command sed -n '1!p' | command cut -d' ' -f1 | command shuf)
    do
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2) && sudo snap refresh $i
    done
  }

  [ ! $(command members sudo | command grep $(command whoami)) -a ! $(command members root | command grep $(command whoami)) ] && builtin printf "You are not a sudoer!" && return 121
  [ $# -eq 0 ] && SPMs="apt git pip raw snap" || SPMs=$(builtin printf "%s\n" $@ | command sort -diu)
  for s in $SPMs
  do
    case "$s" in
                 all)
                   __update_apt && __update_git && __update_pip && __update_raw && __update_snap;;
                 apt)
                   __update_apt;;
                 git)
                   __update_git;;
      (pip|python)3?)
                   __update_pip;;
                 raw)
                   __update_raw;;
                snap)
                   __update_snap;;
                   *)
                   builtin printf "\a\tUsage:  update [apt | fundle user | git | raw | pip pip3 python python3 | snap | all]\n\tupdate all =:= update apt fundle git pip raw snap\n\tDefault:  update apt git pip raw snap"
  done

  unset -f __update_apt
  unset -f __update_git
  unset -f __update_pip
  unset -f __update_raw
  unset -f __update_snap
}

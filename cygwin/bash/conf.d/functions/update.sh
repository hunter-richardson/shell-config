#!/bin/bash

function update() {
  function __update_git() {
    sudo updatedb
    gits=$(command dirname $(sudo locate -eqr '/my-config'))
    for i in $(ls $gits)
    do
      git -C $gits/$i config --get remote.origin.url
      sudo git -C $gits/$i pull
    done
    unset gits
  }

  function __update_pip() {
    for i in $(command sudo pip3 list --format=freeze | cut -d= -f1)
    do
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2)
      sudo pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org $i -U -vvv
    done
  }

  if [ $# -eq 0 ]
  then
    SPMs="git pip"
  else
    SPMs=$(builtin printf "%s\n" $@ | command sort -diu)
  fi
  for s in $SPMs
  do
    case "$s" in
                 all)
                      __update_git
                   && __update_pip
                   ;;
                 git)
                   __update_git
                   ;;
      (pip|python)3?)
                   __update_pip
                   ;;
                   *)
                   builtin printf "\a\tUsage:  update [git | pip pip3 python python3 all]\n\tupdate all =:= update git pip \n\tDefault:  update git pip"
  done

  unset -f __update_apt
  unset -f __update_git
  unset -f __update_pip
  unset -f __update_raw
  unset -f __update_snap
}

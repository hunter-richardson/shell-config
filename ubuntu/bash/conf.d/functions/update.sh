#!/bin/bash

function update() {
  function __update_apt() {
    sudo apt-fast update && sudo apt-fast autoremove -y && sudo apt-fast upgrade -y && sudo apt-fast install -fy && sudo apt-fast clean -y
  }

  function __update_brew() {
    command brew update -v && command brew cleanup -v
    [ -n $(command brew outdated -v) ] && command brew upgrade -v
  }

  function __update_git() {
    sudo updatedb
    for i in $(sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
    do
      current=$(command git -C $i rev-parse --short HEAD)
      url=$(command git -C $i config --get remote.origin.url)
      builtin printf 'Updating %s ...\n' $url
      [ ! $(command git -C $(command dirname $i) diff-index --quiet HEAD) ] && builtin printf '%sLocal Changes:%s\n' $(format red) $(format normal) && builtin printf '\t%s\n' (command git -C (command dirname $i) status --porcelain)
      sudo git -C (command dirname $i) pull --verbose
      if [ $current != $(command git -C $i rev-parse --short HEAD) ]
      then
        [[ $i =~ */hunter-richardson/shell-config/.git ] && builtin source /etc/bash/config.sh && command tmux source /etc/tmux/conf || [[ $i =~ */tmux-plugins/tpm/.git ]] && command tmux source /etc/tmux/conf
      fi
      builtin unset current url
    done
  }

  function __update_snap() {
    for i in $(sudo snap list | command sed -n '1!p' | command cut -d' ' -f1 | command shuf)
    do
      builtin printf '%s\n' (command whereis $i | command cut -d' ' -f2) && sudo snap refresh $i
    done
  }

  [ ! $(command members sudo | command grep $(command whoami)) -a ! $(command members root | command grep $(command whoami)) ] && builtin printf "You are not a sudoer!" && return 121
  [ $(command nmcli networking connectivity check) != 'full' ] && builtin printf 'Unable to open an Internet connection' && return 0
  [ $# -eq 0 ] && SPMs="apt brew git snap" || SPMs=$(builtin printf "%s\n" $@ | command sort -diu)
  for s in $SPMs
  do
    case "$s" in
       all)
         __update_apt && __update_brew && __update_git && __update_snap;;
       apt)
         __update_apt;;
       brew)
         __update_brew;;
       git)
         __update_git;;
       raw)
         __update_raw;;
      snap)
         __update_snap;;
         *)
         builtin printf "\a\tUsage:  update [apt | brew | git | snap | all]\n\tupdate all =:= update apt brew git snap\n\tDefault:  update apt git snap"
  done

  builtin unset -f __update_apt __update_git __update_pip __update_raw __update_snap
}

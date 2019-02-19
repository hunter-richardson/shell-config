#!/usr/bin/fish

function gclone() {
  if [ $(command members sudo | command grep $(command whoami)) ] || [ $(command members root | command grep $(command whoami)) ]
  then
    [ $# -eq 0 ] && builtin "No repository selected!" && return 2
    for i in $@
    do
      IFS='/' builtin read -ra URL_PARTS <<< $i
      repo=$(builtin echo ${URL_PARTS[-1]} | command cut -d'.' -f1)
      [ -z $repo ] && builtin "No repository selected!" || sudo git clone --verbose --depth 1 $i /usr/share/git-repos/$repo
    done
  else
    builtin printf "You are not a sudoer!"
    return 121
  fi
}

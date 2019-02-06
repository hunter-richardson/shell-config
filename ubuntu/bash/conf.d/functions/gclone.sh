#!/usr/bin/fish

function gclone() {
  if [ $(command members sudo | command grep $(command whoami)) -o $(command members root | command grep $(command whoami)) ]
  then
    if [ $# -eq 0 ]
    then
      builtin "No repository selected!"
      return 2
    else
      for i in $@
      do
        IFS='/' builtin read -ra URL_PARTS <<< $i
        repo=$(builtin echo ${URL_PARTS[-1]} | command cut -d'.' -f1)
        if [ -z $repo ]
        then
          builtin "No repository selected!"
        else
          sudo git clone --verbose --depth 1 $i /usr/share/git-repos/$repo
        fi
      done
  else
    builtin printf "You are not a sudoer!"
    return 121
  fi
}

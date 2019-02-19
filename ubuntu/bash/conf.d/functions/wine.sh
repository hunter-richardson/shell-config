function wine() {
  [ -z "$@" ] && builtin printf 'No arguments given!' && return 1
  if [ -z $(command -v wine) ]
  then
    builtin printf 'Wine not installed!' && builtin return 1
  elif [[ " $(command members wine-user) " =~ " $(command whoami) " ]]
  then
    for i in $@
    do
      [[ $i =~ ^https?:// ]] && command wget $i | sudo --user='wine' --command='command wine start - & builtin disown' || sudo --user='wine' --command='command wine start $i & builtin disown'
    done
  else
    builtin printf "You aren't a wine drinker..." && builtin return 1
  end
}

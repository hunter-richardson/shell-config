MY_DIR=$(readlink -f $(dirname $BASH_SOURCE))
source $MY_DIR/format.sh
for i in $(command ls -1 $MY_DIR $MY_DIR/conf.d $MY_DIR/functions)
do
  builtin source $i && builtin printf 'source %s\n' $i
done
unset MY_DIR

[ -n "$(command -v pip)" -a -n "$(command pip show thefuck)" ] && eval "$(thefuck --alias --enable-experimental-instant-mode)" && builtin printf 'eval $(thefuck --alias --enable-experimental-instant-mode)'

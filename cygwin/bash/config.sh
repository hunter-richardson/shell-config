MY_DIR=$(readlink -f $(dirname $BASH_SOURCE))
source $MY_DIR/format.sh
for i in $(command ls -1 $MY_DIR $MY_DIR/conf.d $MY_DIR/functions)
do
  source $i/*.sh
done
unset MY_DIR

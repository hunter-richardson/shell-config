MY_DIR=$(dirname $BASH_SOURCE)
builtin source $MY_DIR/format.sh
for i in $(command ls -1 $MY_DIR $MY_DIR/conf.d $MY_DIR/functions)
do
  builtin source $i/*.sh
done
builtin unset MY_DIR

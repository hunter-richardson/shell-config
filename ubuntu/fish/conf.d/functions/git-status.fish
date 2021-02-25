#!/usr/bin/fish

function status -d 'Show modified files under git version control'
  for d in (sudo locate -eiqr '\/.git$' | command grep -Ev '/\.(config|linuxbrew)/' | command shuf)
    builtin set -l src (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f3 | command cut -d. -f1 | builtin string upper);
      and builtin set -l iden (command basename (command git -C (command dirname $i) config --get remote.origin.url | command cut -d/ -f4,5 | builtin string replace / : | builtin string replace hunter-richardson \$ME) .git);
      and if builtin test -n (command git -C (command dirname $i) status --porcelain);
      and builtin printf '%s%s%s/%s%s%s ...\n' $bold $blue $src $red $iden $normal;
      and command git -C $dir status --porcelain | command tr -s ' ' :
  end
end


#!/usr/bin/fish

builtin test (command -v pip3) -a (command pip3 show thefuck);
  and function fuck -d 'integrate fish with https://github.com/nvbn/thefuck'
        set -l TF_PYTHONIOENCODING $PYTHONIOENCODING;
        set -x TF_ALIAS fuck
        set -x TF_SHELL_ALIASES (alias)
        set -x TF_HISTORY (fc -ln -10)
        set -x PYTHONIOENCODING utf-8
        set -x TF_CMD (thefuck THEFUCK_ARGUMENT_PLACEHOLDER $argv); and eval $TF_CMD
        set -e TF_HISTORY
        set -x PYTHONIOENCODING $TF_PYTHONIOENCODING
        history $TF_CMD
      end
   or  builtin functions -e fuck


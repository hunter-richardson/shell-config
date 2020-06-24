#!/bin/bash

function man {
  GROFF_NO_SGR='yes'
  LESS_TERMCAP_mb=${man_blink:-$(format bold red)}
  LESS_TERMCAP_md=${man_bold:-$(format bold)}
  LESS_TERMCAP_so=${man_standout-$(format grey)}
  LESS_TERMCAP_us=${man_underline:-$(format magenta)}
  LESS_TERMCAP_me=$(builtin printf '\e[0m')
  LESS_TERMCAP_se=$(builtin printf '\e[0m')
  LESS_TERMCAP_ue=$(builtin printf '\e[0m')
  LESS='-R -s'

  [ -z "$MANPATH" ] && MANPATH=$(builtin command -v manpath) || MANPATH=$(builtin printf '%s' $MANPATH | command tr ' ' ':')
  command man $*
}

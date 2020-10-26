function title {
  setopt prompt_subst

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  print -Pn "\e]2;$2:q\a" # set window name
  print -Pn "\e]1;$1:q\a" # set tab name
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

# Runs before showing the prompt
function termsupport_precmd {
  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

# Runs before executing the command
function termsupport_preexec {
  setopt extended_glob

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

precmd_functions+=(termsupport_precmd)
preexec_functions+=(termsupport_preexec)

#!/usr/bin/env zsh

# Hometown
# v3.1.6
# Febrary 2 2025
# https://github.com/olets/hometown-prompt
# Copyright (©) 2021-present Henry Bley-Vroman

typeset -r HOMETOWN_VERSION="3.1.6"

# Git Prompt Kit config
typeset -g GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL=${GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL-$'\n%% '}
typeset -g GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT=${GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT-$'\n# '}

# Hometown config
typeset -gi HOMETOWN_DISTINCT_TRANSIENT_PROMPT=${HOMETOWN_DISTINCT_TRANSIENT_PROMPT:-1}
typeset -gi HOMETOWN_LINEBREAK_AFTER_GIT_REF=${HOMETOWN_LINEBREAK_AFTER_GIT_REF:-1}
typeset -gi HOMETOWN_LINEBREAK_BEFORE_PROMPT=${HOMETOWN_LINEBREAK_BEFORE_PROMPT:-1}
typeset -gi HOMETOWN_NO_LINEBREAK_BEFORE_FIRST_PROMPT=${HOMETOWN_NO_LINEBREAK_BEFORE_FIRST_PROMPT:-1}
typeset -gi HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF=${HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF:-1}
typeset -gi HOMETOWN_REFRESH_INTERVAL=${HOMETOWN_REFRESH_INTERVAL:-0}
typeset -gi HOMETOWN_SET_PSVAR=${HOMETOWN_SET_PSVAR:-1}
typeset -gi HOMETOWN_SHOW_EXTENDED_STATUS=${HOMETOWN_SHOW_EXTENDED_STATUS:-1}
typeset -gi HOMETOWN_USE_TRANSIENT_PROMPT=${HOMETOWN_USE_TRANSIENT_PROMPT:-1}
if (( HOMETOWN_SET_PSVAR )); then
  typeset -g HOMETOWN_CUSTOM=${HOMETOWN_CUSTOM-%v}
else
  typeset -g HOMETOWN_CUSTOM=${HOMETOWN_CUSTOM-%*}
fi

# Hometown transient prompt config
if [[ -z $HOMETOWN_TRANSIENT_PROMPT_CONTEXT ]]; then
  typeset -gA HOMETOWN_TRANSIENT_PROMPT_CONTEXT
fi

if (( HOMETOWN_DISTINCT_TRANSIENT_PROMPT )); then
  # Hometown transient prompt config: Git Prompt Kit
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND]-1}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS]-1}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_TOOL_NAMES]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_TOOL_NAMES]-1}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS]-0}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT]-0}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL]-$'\n'}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT]-$'\n'}
  # Hometown transient prompt config: Hometown
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_CUSTOM]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_CUSTOM]-'%F{%2v}%3v%f %(5V.%5v %v - %W %*.%v-%*)'}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_AFTER_GIT_REF]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_AFTER_GIT_REF]-0}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_BEFORE_PROMPT]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_BEFORE_PROMPT]-0}
  HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF]-1}
fi

# Is the current prompt the first?
typeset -g HOMETOWN_IS_FIRST_PROMPT=2
typeset -g HOMETOWN_IS_NOT_FIRST_PROMPT=

_hometown_transient_prompt() {
  emulate -L zsh

  local key
  local key_saved
  local value

  typeset -gA TRANSIENT_PROMPT_ENV

  TRANSIENT_PROMPT_PRETRANSIENT() {
    emulate -L zsh

    _git_prompt_kit_update_git
    _git_prompt_kit_update_nongit
  }

  TRANSIENT_PROMPT_PROMPT=$PROMPT
  
  # cannot use `for key value in ${(kv)…}` because that has undesired results when values are empty
  for key in ${(k)HOMETOWN_TRANSIENT_PROMPT_CONTEXT}; do
    value=$HOMETOWN_TRANSIENT_PROMPT_CONTEXT[$key]

    # back up context
    typeset -g _hometown_${key}_saved=${(P)key}

    # apply transient prompt context
    typeset -g "$key"="$value"
    
    # share transient prompt context with zsh-transient-prompt
    TRANSIENT_PROMPT_ENV[$key]=$HOMETOWN_TRANSIENT_PROMPT_CONTEXT[$key]
  done

  TRANSIENT_PROMPT_TRANSIENT_PROMPT=$(_hometown_build_prompt)

  # restore backed up context
  for key in ${(k)HOMETOWN_TRANSIENT_PROMPT_CONTEXT}; do
    typeset key_saved=_hometown_${key}_saved
    typeset -g $key=${(P)key_saved}
    unset $key_saved
  done

  'builtin' 'source' ${_hometown_source_path}/zsh-transient-prompt/transient-prompt.zsh-theme
}

_hometown_precmd() {
  local -i exit_code=$?

  emulate -L zsh

  local -i different_day
  local prompt_drawn_date=${(%):-%W}
  local prompt_drawn_time=${(%):-%*}

  (( HOMETOWN_IS_FIRST_PROMPT )) && (( HOMETOWN_IS_FIRST_PROMPT-- ))
  if (( ! HOMETOWN_IS_FIRST_PROMPT )); then
    HOMETOWN_IS_FIRST_PROMPT=
    HOMETOWN_IS_NOT_FIRST_PROMPT=1
  fi

  if (( HOMETOWN_SET_PSVAR )); then
    if [[ -n $psvar[4] && $psvar[4] != $prompt_drawn_date ]]; then
      different_day=1
    fi
    
    psvar=( )

    # 1v (aka v) is drawn time
    psvar+=( $prompt_drawn_time )

    # 2v is exit code color
    if (( exit_code )); then
      psvar+=( $GIT_PROMPT_KIT_COLOR_FAILED )
    else
      psvar+=( $GIT_PROMPT_KIT_COLOR_SUCCEEDED )
    fi

    # 3v is char
    if [[ ${(%):-%#} = \# ]]; then
      psvar+=( $(print -P $GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT) )
    else
      psvar+=( $(print -P $GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL) )
    fi

    # 4v is date
    psvar+=( $prompt_drawn_date )

    # 5v is whether the prompt was drawn before today
    (( different_day )) && psvar+=( 1 )
  fi
}

_hometown_git_prompt() {
  emulate -L zsh

  local git_prompt=

  if (( HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF )); then
    git_prompt+='${GIT_PROMPT_KIT_REF:+ }'
  else
    git_prompt+='${GIT_PROMPT_KIT_REF:+\n}'
  fi

  git_prompt+='${GIT_PROMPT_KIT_REF:+$GIT_PROMPT_KIT_REF}'

  if (( HOMETOWN_LINEBREAK_AFTER_GIT_REF )); then
    if (( HOMETOWN_SHOW_EXTENDED_STATUS )); then
      # Add a line break after the Git ref if there's any of Git extended status, Git status, or Git action
      git_prompt+='${${GIT_PROMPT_KIT_STATUS_EXTENDED:-${GIT_PROMPT_KIT_STATUS:-${GIT_PROMPT_KIT_ACTION}}}:+\n}'
    else
      # Add a line break after the Git ref if there's either Git status or Git action
      git_prompt+='${${GIT_PROMPT_KIT_STATUS:-${GIT_PROMPT_KIT_ACTION}}:+\n}'
    fi
  else
    if (( HOMETOWN_SHOW_EXTENDED_STATUS )); then
      # Add a space after the Git ref if there's any of Git extended status, Git status, or Git action
      git_prompt+='${${GIT_PROMPT_KIT_STATUS_EXTENDED:-${GIT_PROMPT_KIT_STATUS:-${GIT_PROMPT_KIT_ACTION}}}:+ }'
    else
      # Add a space after the Git ref if there's either Git status or Git action
      git_prompt+='${${GIT_PROMPT_KIT_STATUS:-${GIT_PROMPT_KIT_ACTION}}:+ }'
    fi
  fi

  if (( HOMETOWN_SHOW_EXTENDED_STATUS )); then
    git_prompt+='${GIT_PROMPT_KIT_STATUS_EXTENDED}'

    # Add a space after the extended Git prompt if there's an extended Git status and either a Git status or a Git action
    git_prompt+='${GIT_PROMPT_KIT_STATUS_EXTENDED:+${${GIT_PROMPT_KIT_STATUS:-$GIT_PROMPT_KIT_ACTION}:+ }}'
  fi

  git_prompt+='${GIT_PROMPT_KIT_STATUS}'

  # Add a space after the Git status if there's a Git action
  git_prompt+='${GIT_PROMPT_KIT_STATUS:+${GIT_PROMPT_KIT_ACTION:+ }}'

  git_prompt+='${GIT_PROMPT_KIT_ACTION}'

  'builtin' 'echo' $git_prompt
}

_hometown_build_prompt() {
  emulate -L zsh

  local prompt=

  # Blank line after result of previous command
  if (( HOMETOWN_LINEBREAK_BEFORE_PROMPT )); then
    if (( HOMETOWN_NO_LINEBREAK_BEFORE_FIRST_PROMPT )); then
      prompt+='${HOMETOWN_IS_NOT_FIRST_PROMPT:+\n}'
    else
      prompt+=$'\n'
    fi
  fi

  # User and host
  prompt+='${GIT_PROMPT_KIT_USERHOST:+$GIT_PROMPT_KIT_USERHOST }'

  # Custom (24h format HH:MM:SS time by default)
  prompt+='${HOMETOWN_CUSTOM:+$HOMETOWN_CUSTOM }'

  # Working directory
  prompt+='${GIT_PROMPT_KIT_CWD}'

  # Git
  prompt+=$(_hometown_git_prompt)

  # Prompt character
  prompt+='${GIT_PROMPT_KIT_CHAR}'

  'builtin' 'echo' $prompt
}

_hometown_init() {
  emulate -L zsh

  # if installed with Homebrew, will not have .gitmodules
  if [[ -f ${_hometown_source_path}/.gitmodules && ! -f ${_hometown_source_path}/git-prompt-kit/git-prompt-kit.plugin.zsh ]]; then
    'builtin' 'print' Finishing installing Hometown
    'command' 'git' submodule update --init --recursive &>/dev/null
  fi

  if ! [[ -f ${_hometown_source_path}/git-prompt-kit/git-prompt-kit.zsh && -f ${_hometown_source_path}/zsh-transient-prompt/transient-prompt.zsh-theme ]]; then
    'builtin' 'print' There was problem finishing installing Hometown
    return
  fi

  GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX=__hometown
  GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME=HOMETOWN

  'builtin' 'source' $_hometown_source_path/git-prompt-kit/git-prompt-kit.zsh

  PROMPT=$(_hometown_build_prompt)

  if (( HOMETOWN_SET_PSVAR || HOMETOWN_LINEBREAK_BEFORE_PROMPT )); then
    (( ${+precmd_functions} )) || typeset -ga precmd_functions

    precmd_functions+=_hometown_precmd
  fi

  if (( HOMETOWN_SET_PSVAR )); then
    psvar=( )
    psvar[4]=${(%):-%W}
  fi

  if (( HOMETOWN_USE_TRANSIENT_PROMPT )); then
    _hometown_transient_prompt
  fi

  if (( HOMETOWN_REFRESH_INTERVAL )); then
    zmodload -i zsh/sched
    _hometown_scheduled_refresh
  fi
}

_hometown_scheduled_refresh() {
  emulate -L zsh

  # With gratitude to Peter Stephenson
  # https://www.zsh.org/mla/users/2007/msg00946.html

  # Remove existing event, so that multiple calls to
  # "_hometown_scheduled_refresh" work OK.  (You could put one in precmd to push
  # the timer 30 seconds into the future, for example.)
  typeset -i i=${"${(@)zsh_scheduled_events#*:*:}"[(I)_hometown_scheduled_refresh]}
  (( i )) && sched -$i

  # update
  _git_prompt_kit_update_git

  # Test that zle is running before calling the widget (recommended
  # to avoid error messages).
  # Otherwise it updates on entry to zle, so there's no loss.
  zle && zle reset-prompt && zle -R

  sched +$(( HOMETOWN_REFRESH_INTERVAL )) _hometown_scheduled_refresh
}

typeset -r _hometown_source_path=${0:A:h}

setopt prompt_subst
_hometown_init


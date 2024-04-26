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
typeset -g HOMETOWN_CUSTOM=${HOMETOWN_CUSTOM-%*}
typeset -gi HOMETOWN_LINEBREAK_AFTER_GIT_REF=${HOMETOWN_LINEBREAK_AFTER_GIT_REF:-1}
typeset -gi HOMETOWN_LINEBREAK_BEFORE_PROMPT=${HOMETOWN_LINEBREAK_BEFORE_PROMPT:-1}
typeset -gi HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF=${HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF:-1}
typeset -gi HOMETOWN_SHOW_EXTENDED_STATUS=${HOMETOWN_SHOW_EXTENDED_STATUS:-1}
typeset -gi HOMETOWN_USE_TRANSIENT_PROMPT=${HOMETOWN_USE_TRANSIENT_PROMPT:-1}

# Hometown transient prompt config
if [[ -z $HOMETOWN_TRANSIENT_PROMPT_CONTEXT ]]; then
  typeset -gA HOMETOWN_TRANSIENT_PROMPT_CONTEXT
fi
# Hometown transient prompt config: Git Prompt Kit
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND]-1}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS]-1}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_TOOL_NAMES]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_HIDE_TOOL_NAMES]-1}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS]-0}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_CWD_MAX_TRAILING_COUNT]-0}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL]-$'\n'}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT]-$'\n'}
# Hometown transient prompt config: Hometown
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_AFTER_GIT_REF]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_AFTER_GIT_REF]-0}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_BEFORE_PROMPT]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_LINEBREAK_BEFORE_PROMPT]-0}
HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF]=${HOMETOWN_TRANSIENT_PROMPT_CONTEXT[HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF]-1}

_hometown_transient_prompt() {
  zle -N send-break _hometown_transient_prompt-send-break
  function _hometown_transient_prompt-send-break {
    _hometown_transient_prompt-zle-line-finish
    zle .send-break
  }

  zle -N zle-line-finish _hometown_transient_prompt-zle-line-finish
  function _hometown_transient_prompt-zle-line-finish {
    local key
    local value
    local transient_prompt
    
    (( ! _hometown_transient_prompt_fd )) && {
      sysopen -r -o cloexec -u _hometown_transient_prompt_fd /dev/null
      zle -F $_hometown_transient_prompt_fd _hometown_transient_prompt_restore_prompt
    }

    # cannot use `for key value in ${(kv)…}` because that has undesired results when values are empty
    for key in ${(k)HOMETOWN_TRANSIENT_PROMPT_CONTEXT}; do
      value=$HOMETOWN_TRANSIENT_PROMPT_CONTEXT[$key]

      # back up context
      typeset -g _hometown_${key}_saved=${(P)key}

      # apply transient prompt context
      typeset -g "$key"="$value"
    done

    _git_prompt_kit_update_git
    _git_prompt_kit_update_nongit
    transient_prompt=$(_hometown_build_prompt)

    zle && PROMPT=$transient_prompt && zle reset-prompt && zle -R
    
    # restore backed up context
    local key_saved
    for key in ${(k)HOMETOWN_TRANSIENT_PROMPT_CONTEXT}; do
      typeset key_saved=_hometown_${key}_saved
      typeset -g $key=${(P)key_saved}
      unset $key_saved
    done
  }

  function _hometown_transient_prompt_restore_prompt {
    exec {1}>&-
    (( ${+1} )) && zle -F $1
    _hometown_transient_prompt_fd=0
    PROMPT=$(_hometown_build_prompt)
    zle reset-prompt
    zle -R
  }

  (( ${+precmd_functions} )) || typeset -ga precmd_functions

  (( ${#precmd_functions} )) || {
    do_nothing() {
      true
    }

    precmd_functions=( do_nothing )
  }

  precmd_functions+=_hometown_transient_prompt_precmd
  function _hometown_transient_prompt_precmd {
    TRAPINT() {
      zle && _hometown_transient_prompt-zle-line-finish
      return $(( 128 + $1 ))
    }
  }
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
    prompt+=$'\n'
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

  local key
  local value

  # if installed with Homebrew, will not have .gitmodules
  if [[ -f ${_hometown_source_path}/.gitmodules && ! -f ${_hometown_source_path}/git-prompt-kit/git-prompt-kit.plugin.zsh ]]; then
    'builtin' 'print' Finishing installing Hometown
    'command' 'git' submodule update --init --recursive &>/dev/null
  fi

  if ! [[ -f ${_hometown_source_path}/git-prompt-kit/git-prompt-kit.zsh ]]; then
    'builtin' 'print' There was problem finishing installing Hometown
    return
  fi

  GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX=__hometown
  GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME=HOMETOWN

  'builtin' 'source' $_hometown_source_path/git-prompt-kit/git-prompt-kit.zsh

  PROMPT=$(_hometown_build_prompt)

  if (( HOMETOWN_USE_TRANSIENT_PROMPT )); then
    autoload -Uz add-zsh-hook
    _hometown_transient_prompt
  fi
}

typeset -r _hometown_source_path=${0:A:h}

setopt prompt_subst
_hometown_init

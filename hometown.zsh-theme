#!/usr/bin/env zsh

# Hometown
# v3.0.0
# Dec 5 2023
# https://github.com/olets/hometown-prompt
# Copyright (©) 2021-present Henry Bley-Vroman

typeset -r HOMETOWN_PROMPT_VERSION="3.0.0"

typeset -g HOMETOWN_CUSTOM=${HOMETOWN_CUSTOM-%*}
typeset -gi HOMETOWN_LINEBREAK_AFTER_GIT_REF=${HOMETOWN_LINEBREAK_AFTER_GIT_REF:-1}
typeset -gi HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF=${HOMETOWN_NO_LINEBREAK_BEFORE_GIT_REF:-1}
typeset -gi HOMETOWN_SHOW_EXTENDED_STATUS=${HOMETOWN_SHOW_EXTENDED_STATUS:-1}

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
  prompt+=$'\n'

  # User and host
  prompt+='${GIT_PROMPT_KIT_USERHOST:+$GIT_PROMPT_KIT_USERHOST }'

  # Custom (24h format HH:MM:SS time by default)
  prompt+='${HOMETOWN_CUSTOM:+$HOMETOWN_CUSTOM }'

  # Working directory
  prompt+='${GIT_PROMPT_KIT_CWD}'

  # Git
  prompt+=$(_hometown_git_prompt)

  # Prompt character
  prompt+=$'\n'
  prompt+='${GIT_PROMPT_KIT_CHAR:+$GIT_PROMPT_KIT_CHAR }'

  'builtin' 'echo' $prompt
}

_hometown_init() {
  emulate -L zsh

  local dir

  if ! (( $# )); then
    'builtin' 'printf' Hometown could not be initialized
    return
  fi

  dir=$1

  GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX=__hometown
  GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME=HOMETOWN

  'builtin' 'source' $dir/git-prompt-kit/git-prompt-kit.zsh

  PROMPT=$(_hometown_build_prompt)
}

_hometown_init ${0:A:h}

#!/usr/bin/env zsh

# Hometown
# https://github.com/olets/hometown-prompt
# v2.0.1
# Copyright (©) 2021-present Henry Bley-Vroman

typeset -g HOMETOWN_PROMPT_CUSTOM=${HOMETOWN_PROMPT_CUSTOM-}
typeset -gi HOMETOWN_PROMPT_SHOW_EXTENDED_STATUS=${HOMETOWN_PROMPT_SHOW_EXTENDED_STATUS:-1}

_hometown_prompt_git_prompt() {
  emulate -L zsh

  local git_prompt=

  git_prompt+='$GIT_PROMPT_KIT_REF'

  if (( HOMETOWN_PROMPT_SHOW_EXTENDED_STATUS )); then
    git_prompt+='$GIT_PROMPT_KIT_STATUS_EXTENDED'

    # Add a space after the extended Git prompt if there's an extended Git status and either a Git status or a Git action
    git_prompt+='${GIT_PROMPT_KIT_STATUS_EXTENDED:+${${GIT_PROMPT_KIT_STATUS:-$GIT_PROMPT_KIT_ACTION}:+ }}'
  fi

  git_prompt+='$GIT_PROMPT_KIT_STATUS'

  # Add a space after the Git status if there's a Git action
  git_prompt+='${GIT_PROMPT_KIT_STATUS:+${GIT_PROMPT_KIT_ACTION:+ }}'

  git_prompt+='$GIT_PROMPT_KIT_ACTION'

  'builtin' 'echo' $git_prompt
}

_hometown_prompt_build_prompt() {
  emulate -L zsh

  local prompt=

  # Blank line after result of previous command
  prompt+=$'\n'

  # User and host
  prompt+='${GIT_PROMPT_KIT_USERHOST:+$GIT_PROMPT_KIT_USERHOST }'

  # Time
  prompt+=$'%* '

  # Custom (empty by default)
  prompt+='${HOMETOWN_PROMPT_CUSTOM:+$HOMETOWN_PROMPT_CUSTOM }'

  # Working directory
  prompt+='$GIT_PROMPT_KIT_WORKDIR'

  # Git
  # add a space if GIT_PROMPT_KIT_NO_LINEBREAK_BEFORE_GIT_REF, otherwise add a linebreak
  prompt+='${GIT_PROMPT_KIT_HEAD:+${${GIT_PROMPT_KIT_NO_LINEBREAK_BEFORE_GIT_REF:+ }:-\n}}'
  prompt+=$(_hometown_prompt_git_prompt)

  # Prompt character
  prompt+=$'\n'
  prompt+='${GIT_PROMPT_KIT_CHAR:+$GIT_PROMPT_KIT_CHAR }'

  'builtin' 'echo' $prompt
}

_hometown_prompt_init() {
  emulate -L zsh

  local dir

  if ! (( $# )); then
    'builtin' 'printf' Hometown could not be initialized
  fi

  dir=$1

  GIT_PROMPT_KIT_GITSTATUS_FUNCTIONS_SUFFIX=__hometown_prompt
  GIT_PROMPT_KIT_GITSTATUSD_INSTANCE_NAME=HOMETOWN_PROMPT

  'builtin' 'source' $dir/git-prompt-kit/git-prompt-kit.zsh

  PROMPT=$(_hometown_prompt_build_prompt)
}

_hometown_prompt_init ${0:A:h}
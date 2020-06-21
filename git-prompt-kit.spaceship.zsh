# git_prompt_kit
#
# Git Prompt Kit section for Spaceship
# Requires Git Prompt Kit
# https://github.com/olets/git-prompt-kit
# Add git_prompt_kit to SPACESHIP_PROMPT_ORDER

SPACESHIP_GIT_PROMPT_KIT_PREFIX=${SPACESHIP_GIT_PROMPT_KIT_PREFIX:-}
SPACESHIP_GIT_PROMPT_KIT_SUFFIX=${SPACESHIP_GIT_PROMPT_KIT_SUFFIX:- }
# colors are set with the GIT_PROMPT_KIT_ configuration variables

spaceship_git_prompt_kit() {
  [[ $SPACESHIP_GIT_PROMPT_KIT_SHOW == false ]] && return

  local 'git_prompt_kit_status'

  git_prompt_kit_status=$(_git_prompt_kit_git_prompt)

  [[ -z $git_prompt_kit_status ]] && return

  spaceship::section \
    "" \
    "$SPACESHIP_GIT_PROMPT_KIT_PREFIX" \
    "$SPACESHIP_GIT_PROMPT_KIT_SYMBOL$(print -P $git_prompt_kit_status)" \
    "$SPACESHIP_GIT_PROMPT_KIT_SUFFIX"
}

# Porcelain Prompt
# https://github.com/olets/porcelain-prompt
# Copyright (c) 2019-2020 Henry Bley-Vroman
#
# Forked from and requires gitstatus prompt
# https://github.com/romkatv/gitstatus


_PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE=${_PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE=1}
_PORCELAIN_PROMPT_SHOW_TOOL_NAMES=${_PORCELAIN_PROMPT_SHOW_TOOL_NAMES=0}

function if_not_zero() {
  [ "$1" = 0 ] && echo "$1"
}

function gitstatus_prompt_update() {
  emulate -L zsh
  typeset -g GITSTATUS_PROMPT=''
  typeset -g WHERE=

  # Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  # asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  local added_staged_count
  local p
  local w
  local unstaged_count
  local node_version=''

  local color_inactive='%248F'
  local color_action='%199F'
  local color_active_staged='%2F'
  local color_active_unstaged='%1F'
  local color_remote='%216F'
  local color_where='%140F'
  local color_stash='%81F'

  local symbol_modified='_M'
  local symbol_modified_staged='M_'
  local symbol_added='??'
  local symbol_added_staged='A_'
  local symbol_deleted='_D'
  local symbol_deleted_staged='D_'
  local symbol_conflicted='UU'
  local symbol_behind='↓'
  local symbol_ahead='↑'
  local symbol_stash='⇲'
  local symbol_assume_unchanged='⥱'
  local symbol_skip_worktree='⤳'
  local dirty=0
  local symbol_branch='#'
  local symbol_commit='•'

  p+="$color_inactive"
  (( VCS_STATUS_STASHES )) && p+="$color_stash$VCS_STATUS_STASHES"
  p+="$symbol_stash "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_ASSUME_UNCHANGED )) && p+="$color_stash$VCS_STATUS_NUM_ASSUME_UNCHANGED"
  p+="$symbol_assume_unchanged "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_SKIP_WORKTREE )) && p+="$color_stash$VCS_STATUS_NUM_SKIP_WORKTREE"
  p+="$symbol_skip_worktree "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_UNTRACKED )) && p+="$color_active_unstaged$VCS_STATUS_NUM_UNTRACKED" && dirty=1
  p+="$symbol_added "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_CONFLICTED )) && p+="$color_active_unstaged$VCS_STATUS_NUM_CONFLICTED" && dirty=1
  p+="$symbol_conflicted "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_UNSTAGED_DELETED )) && p+="$color_active_unstaged$VCS_STATUS_NUM_UNSTAGED_DELETED" && dirty=1
  p+="$symbol_deleted "

  p+="$color_inactive"
  (( unstaged_count = VCS_STATUS_NUM_UNSTAGED - VCS_STATUS_NUM_UNSTAGED_DELETED ))
  (( $unstaged_count )) && p+="$color_active_unstaged$unstaged_count" && dirty=1
  p+="$symbol_modified "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_STAGED_NEW )) && p+="$color_active_staged$VCS_STATUS_NUM_STAGED_NEW" && dirty=1
  p+="$symbol_added_staged "

  p+="$color_inactive"
  (( VCS_STATUS_NUM_STAGED_DELETED )) && p+="$color_active_staged$VCS_STATUS_NUM_STAGED_DELETED" && dirty=1
  p+="$symbol_deleted_staged "

  p+="$color_inactive"
  (( added_staged_count = VCS_STATUS_NUM_STAGED - VCS_STATUS_NUM_STAGED_NEW - VCS_STATUS_NUM_STAGED_DELETED ))
  (( added_staged_count )) && p+="$color_active_staged$added_staged_count" && dirty=1
  p+="$symbol_modified_staged"

  w=' '
  if (( $dirty )); then
    w+="${color_where}"
  else
    w+="$color_inactive"
  fi

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    ref="$symbol_branch$VCS_STATUS_LOCAL_BRANCH"
  else
    ref=$symbol_commit${VCS_STATUS_COMMIT[1,8]}
  fi
  w+="$ref "

  [[ -n $VCS_STATUS_TAG ]] && w+="$symbol_tag$VCS_STATUS_TAG "

  w+="$color_inactive"
  if [[ -z $VCS_STATUS_REMOTE_BRANCH ]]; then
    w+="${color_remote}local"
  else
    (( VCS_STATUS_COMMITS_BEHIND )) && w+="$color_where$VCS_STATUS_COMMITS_BEHIND"
    w+="$symbol_behind "

    (( VCS_STATUS_COMMITS_AHEAD )) && w+="$color_remote$VCS_STATUS_COMMITS_AHEAD"
    w+="$symbol_ahead "

    if [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
      w+="$color_remote${VCS_STATUS_REMOTE_NAME}/${VCS_STATUS_REMOTE_BRANCH}"
    elif [[ $VCS_STATUS_REMOTE_NAME != 'origin' ]]; then
      w+="$color_remote$VCS_STATUS_REMOTE_NAME"
    fi
  fi

  if (( _PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE )); then
    WHERE="${w}%f"
  else
    p+="$w"
  fi

  p+="$color_inactive"
  [[ -n $VCS_STATUS_ACTION ]] && p+=" $color_action$VCS_STATUS_ACTION"

  (( _PORCELAIN_PROMPT_SHOW_TOOL_NAMES )) && GITSTATUS_PROMPT+="Git "
  GITSTATUS_PROMPT+="${p}%f"
}

# Start gitstatusd instance with name "MY". The same name is passed to
# gitstatus_query in gitstatus_prompt_update. The flags with -1 as values
# enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

# On every prompt, fetch git status and set GITSTATUS_PROMPT.
autoload -Uz add-zsh-hook
add-zsh-hook precmd gitstatus_prompt_update

# Build the prompt
#
PROMPT=
PROMPT+=$'\n'

# user@host
PROMPT+='%70F%n@%m%f '

# time
PROMPT+=$'%* '

# cwd
PROMPT+='%39F%2~%f'

# ref
PROMPT+='${WHERE:+$WHERE}'
PROMPT+=$'\n'

# status
PROMPT+='${GITSTATUS_PROMPT:+$GITSTATUS_PROMPT
}'

# prompt. %/# (normal/root); green/red (ok/error)
PROMPT+='%F{%(?.76.196)}%#%f '

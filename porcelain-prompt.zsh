# Porcelain Prompt
# https://github.com/olets/porcelain-prompt
# Copyright (c) 2019-2020 Henry Bley-Vroman
#
# Forked from and requires gitstatus prompt
# https://github.com/romkatv/gitstatus

# Configurable options
PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE=${PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE:=1}
PORCELAIN_PROMPT_SHOW_TOOL_NAMES=${PORCELAIN_PROMPT_SHOW_TOOL_NAMES:=0}
PORCELAIN_PROMPT_DEFAULT_USER=${PORCELAIN_PROMPT_DEFAULT_USER:=}
PORCELAIN_PROMPT_DEFAULT_HOST=${PORCELAIN_PROMPT_DEFAULT_HOST:=}
PORCELAIN_PROMPT_CWD=${PORCELAIN_PROMPT_CWD:=%2~}

# Configurable symbols
PORCELAIN_PROMPT_SYMBOL_ADDED=${PORCELAIN_PROMPT_SYMBOL_ADDED:=??}
PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED=${PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED:=A_}
PORCELAIN_PROMPT_SYMBOL_AHEAD=${PORCELAIN_PROMPT_SYMBOL_AHEAD:=↑}
PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED=${PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED:=⥱ }
PORCELAIN_PROMPT_SYMBOL_BEHIND=${PORCELAIN_PROMPT_SYMBOL_BEHIND:=↓}
PORCELAIN_PROMPT_SYMBOL_BRANCH=${PORCELAIN_PROMPT_SYMBOL_BRANCH:=#}
PORCELAIN_PROMPT_SYMBOL_COMMIT=${PORCELAIN_PROMPT_SYMBOL_COMMIT:=•}
PORCELAIN_PROMPT_SYMBOL_CONFLICTED=${PORCELAIN_PROMPT_SYMBOL_CONFLICTED:=UU}
PORCELAIN_PROMPT_SYMBOL_DELETED=${PORCELAIN_PROMPT_SYMBOL_DELETED:=_D}
PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED=${PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED:=D_}
PORCELAIN_PROMPT_SYMBOL_HOST=${PORCELAIN_PROMPT_SYMBOL_HOST:=@}
PORCELAIN_PROMPT_SYMBOL_MODIFIED=${PORCELAIN_PROMPT_SYMBOL_MODIFIED:=_M}
PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED=${PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED:=M_}
PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE=${PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE:=⤳ }
PORCELAIN_PROMPT_SYMBOL_STASH=${PORCELAIN_PROMPT_SYMBOL_STASH:=⇲ }

# Configurable colors
PORCELAIN_PROMPT_COLOR_ACTION=${PORCELAIN_PROMPT_COLOR_ACTION:=199}
PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED=${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED:=2}
PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED=${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED:=1}
PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED=${PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED:=81}
PORCELAIN_PROMPT_COLOR_CWD=${PORCELAIN_PROMPT_COLOR_CWD:=39}
PORCELAIN_PROMPT_COLOR_FAIL=${PORCELAIN_PROMPT_COLOR_FAIL:=196}
PORCELAIN_PROMPT_COLOR_HOST=${PORCELAIN_PROMPT_COLOR_HOST:=109}
PORCELAIN_PROMPT_COLOR_INACTIVE=${PORCELAIN_PROMPT_COLOR_INACTIVE:=248}
PORCELAIN_PROMPT_COLOR_REMOTE=${PORCELAIN_PROMPT_COLOR_REMOTE:=216}
PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE=${PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE:=81}
PORCELAIN_PROMPT_COLOR_STASH=${PORCELAIN_PROMPT_COLOR_STASH:=81}
PORCELAIN_PROMPT_COLOR_SUCCESS=${PORCELAIN_PROMPT_COLOR_SUCCESS:=76}
PORCELAIN_PROMPT_COLOR_USER=${PORCELAIN_PROMPT_COLOR_USER:=109}
PORCELAIN_PROMPT_COLOR_WHERE=${PORCELAIN_PROMPT_COLOR_WHERE:=140}

function if_porcelain_prompt_not_zero() {
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
  local dirty=0

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_STASHES )) && p+="%${PORCELAIN_PROMPT_COLOR_STASH}F$VCS_STATUS_STASHES"
  p+="$PORCELAIN_PROMPT_SYMBOL_STASH "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_ASSUME_UNCHANGED )) && p+="%${PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED}F$VCS_STATUS_NUM_ASSUME_UNCHANGED"
  p+="$PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_SKIP_WORKTREE )) && p+="%${PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE}F$VCS_STATUS_NUM_SKIP_WORKTREE"
  p+="$PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_UNTRACKED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$VCS_STATUS_NUM_UNTRACKED" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_ADDED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_CONFLICTED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$VCS_STATUS_NUM_CONFLICTED" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_CONFLICTED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_UNSTAGED_DELETED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$VCS_STATUS_NUM_UNSTAGED_DELETED" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_DELETED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( unstaged_count = VCS_STATUS_NUM_UNSTAGED - VCS_STATUS_NUM_UNSTAGED_DELETED ))
  (( $unstaged_count )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$unstaged_count" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_MODIFIED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_STAGED_NEW )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}F$VCS_STATUS_NUM_STAGED_NEW" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( VCS_STATUS_NUM_STAGED_DELETED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}F$VCS_STATUS_NUM_STAGED_DELETED" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED "

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  (( added_staged_count = VCS_STATUS_NUM_STAGED - VCS_STATUS_NUM_STAGED_NEW - VCS_STATUS_NUM_STAGED_DELETED ))
  (( added_staged_count )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}F$added_staged_count" && dirty=1
  p+="$PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED"

  w=' '
  if (( $dirty )); then
    w+="%${PORCELAIN_PROMPT_COLOR_WHERE}F"
  else
    w+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  fi

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    ref="$PORCELAIN_PROMPT_SYMBOL_BRANCH$VCS_STATUS_LOCAL_BRANCH"
  else
    ref=$PORCELAIN_PROMPT_SYMBOL_COMMIT${VCS_STATUS_COMMIT[1,8]}
  fi
  w+="$ref "

  [[ -n $VCS_STATUS_TAG ]] && w+="$PORCELAIN_PROMPT_SYMBOL_TAG$VCS_STATUS_TAG "

  w+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  if [[ -z $VCS_STATUS_REMOTE_BRANCH ]]; then
    w+="${PORCELAIN_PROMPT_COLOR_REMOTE}local"
  else
    (( VCS_STATUS_COMMITS_BEHIND )) && w+="%${PORCELAIN_PROMPT_COLOR_WHERE}F$VCS_STATUS_COMMITS_BEHIND"
    w+="$PORCELAIN_PROMPT_SYMBOL_BEHIND "

    (( VCS_STATUS_COMMITS_AHEAD )) && w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}F$VCS_STATUS_COMMITS_AHEAD"
    w+="$PORCELAIN_PROMPT_SYMBOL_AHEAD "

    if [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
      w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}F${VCS_STATUS_REMOTE_NAME}/${VCS_STATUS_REMOTE_BRANCH}"
    elif [[ $VCS_STATUS_REMOTE_NAME != 'origin' ]]; then
      w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}F$VCS_STATUS_REMOTE_NAME"
    fi
  fi

  if (( PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE )); then
    WHERE="${w}%f"
  else
    p+="$w"
  fi

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  [[ -n $VCS_STATUS_ACTION ]] && p+=" %${PORCELAIN_PROMPT_COLOR_ACTION}F$VCS_STATUS_ACTION"

  (( PORCELAIN_PROMPT_SHOW_TOOL_NAMES )) && GITSTATUS_PROMPT+="Git "
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
_porcelain_prompt_not_default_user=0
_porcelain_prompt_not_default_host=0

if [[ ${(%):-%n} != $PORCELAIN_PROMPT_DEFAULT_USER ]]; then
  _porcelain_prompt_not_default_user=1
fi

if [[ ${(%):-%m} != $PORCELAIN_PROMPT_DEFAULT_HOST ]]; then
  _porcelain_prompt_not_default_host=1
fi

if (( _porcelain_prompt_not_default_user || _porcelain_prompt_not_default_host )); then
  (( _porcelain_prompt_not_default_user )) && PROMPT+='%F{$PORCELAIN_PROMPT_COLOR_USER}%n$f'
  (( _porcelain_prompt_not_default_host )) && PROMPT+='%F{$PORCELAIN_PROMPT_COLOR_HOST}${PORCELAIN_PROMPT_SYMBOL_HOST}%m%f'
  PROMPT+=' '
fi

# time
PROMPT+=$'%* '

# cwd
PROMPT+='%F{$PORCELAIN_PROMPT_COLOR_CWD}$PORCELAIN_PROMPT_CWD%f'

# ref
PROMPT+='${WHERE:+$WHERE}'
PROMPT+=$'\n'

# status
PROMPT+='${GITSTATUS_PROMPT:+$GITSTATUS_PROMPT
}'

# prompt. %/# (normal/root); green/red (ok/error)
PROMPT+='%F{%(?.$PORCELAIN_PROMPT_COLOR_SUCCESS.$PORCELAIN_PROMPT_COLOR_FAIL)}%#%f '

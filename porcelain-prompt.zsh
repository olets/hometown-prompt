# Porcelain Prompt
# https://github.com/olets/porcelain-prompt
# Copyright (c) 2019-2020 Henry Bley-Vroman
#
# Forked from and requires gitstatus prompt
# https://github.com/romkatv/gitstatus

# Configurable options
PORCELAIN_PROMPT_CWD=${PORCELAIN_PROMPT_CWD:-%2~} # see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Shell-state
PORCELAIN_PROMPT_DEFAULT_USER=${PORCELAIN_PROMPT_DEFAULT_USER-}
PORCELAIN_PROMPT_DEFAULT_HOST=${PORCELAIN_PROMPT_DEFAULT_HOST-}
PORCELAIN_PROMPT_DEFAULT_REMOTE=${PORCELAIN_PROMPT_DEFAULT_REMOTE:-origin}
PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE=${PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE:-1}
PORCELAIN_PROMPT_HIDE_TOOL_NAMES=${PORCELAIN_PROMPT_HIDE_TOOL_NAMES:-1}
PORCELAIN_PROMPT_SHOW_INACTIVE=${PORCELAIN_PROMPT_SHOW_INACTIVE:-1}

# Configurable symbols
PORCELAIN_PROMPT_SYMBOL_ADDED=${PORCELAIN_PROMPT_SYMBOL_ADDED-??}
PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED=${PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED-A_}
PORCELAIN_PROMPT_SYMBOL_AHEAD=${PORCELAIN_PROMPT_SYMBOL_AHEAD-↑}
PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED=${PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED-⥱ }
PORCELAIN_PROMPT_SYMBOL_BEHIND=${PORCELAIN_PROMPT_SYMBOL_BEHIND-↓}
PORCELAIN_PROMPT_SYMBOL_BRANCH=${PORCELAIN_PROMPT_SYMBOL_BRANCH-#}
PORCELAIN_PROMPT_SYMBOL_COMMIT=${PORCELAIN_PROMPT_SYMBOL_COMMIT-•}
PORCELAIN_PROMPT_SYMBOL_CONFLICTED=${PORCELAIN_PROMPT_SYMBOL_CONFLICTED-UU}
PORCELAIN_PROMPT_SYMBOL_DELETED=${PORCELAIN_PROMPT_SYMBOL_DELETED-_D}
PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED=${PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED-D_}
PORCELAIN_PROMPT_SYMBOL_HOST=${PORCELAIN_PROMPT_SYMBOL_HOST-@}
PORCELAIN_PROMPT_SYMBOL_MODIFIED=${PORCELAIN_PROMPT_SYMBOL_MODIFIED-_M}
PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED=${PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED-M_}
PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE=${PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE-⤳ }
PORCELAIN_PROMPT_SYMBOL_STASH=${PORCELAIN_PROMPT_SYMBOL_STASH-⇲ }
PORCELAIN_PROMPT_SYMBOL_TAG=${PORCELAIN_PROMPT_SYMBOL_TAG:-}

# Configurable colors
PORCELAIN_PROMPT_COLOR_ACTION=${PORCELAIN_PROMPT_COLOR_ACTION:-199}
PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED=${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED:-2}
PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED=${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED:-1}
PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED=${PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED:-81}
PORCELAIN_PROMPT_COLOR_CWD=${PORCELAIN_PROMPT_COLOR_CWD:-39}
PORCELAIN_PROMPT_COLOR_FAIL=${PORCELAIN_PROMPT_COLOR_FAIL:-196}
PORCELAIN_PROMPT_COLOR_HOST=${PORCELAIN_PROMPT_COLOR_HOST:-109}
PORCELAIN_PROMPT_COLOR_INACTIVE=${PORCELAIN_PROMPT_COLOR_INACTIVE:-248}
PORCELAIN_PROMPT_COLOR_REMOTE=${PORCELAIN_PROMPT_COLOR_REMOTE:-216}
PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE=${PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE:-81}
PORCELAIN_PROMPT_COLOR_STASH=${PORCELAIN_PROMPT_COLOR_STASH:-81}
PORCELAIN_PROMPT_COLOR_SUCCESS=${PORCELAIN_PROMPT_COLOR_SUCCESS:-76}
PORCELAIN_PROMPT_COLOR_TAG=${PORCELAIN_PROMPT_COLOR_TAG:-140}
PORCELAIN_PROMPT_COLOR_USER=${PORCELAIN_PROMPT_COLOR_USER:-109}
PORCELAIN_PROMPT_COLOR_WHERE=${PORCELAIN_PROMPT_COLOR_WHERE:-140}

function if_porcelain_prompt_not_zero() {
  [ "$1" = 0 ] && echo "$1"
}

function gitstatus_prompt_update() {
  emulate -L zsh
  typeset -g GITSTATUS_PROMPT=''
  typeset -g WHERE

  # Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  # asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  # Set variables for later use

  local added_staged_count
  local dirty=0
  local node_version=''
  local not_default_remote=0
  local p # used while building the prompt
  local unstaged_count
  local w # used while building the "where" (Git commitish, tag, relation to remote)

  (( added_staged_count = VCS_STATUS_NUM_STAGED - VCS_STATUS_NUM_STAGED_NEW - VCS_STATUS_NUM_STAGED_DELETED ))
  (( unstaged_count = VCS_STATUS_NUM_UNSTAGED - VCS_STATUS_NUM_UNSTAGED_DELETED ))

  if [[ $VCS_STATUS_REMOTE_NAME != $PORCELAIN_PROMPT_DEFAULT_REMOTE ]]; then
    not_default_remote=1
  fi

  # Git status: stashes

  if (( VCS_STATUS_STASHES || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_STASHES )) && p+="%${PORCELAIN_PROMPT_COLOR_STASH}F$VCS_STATUS_STASHES"
    p+="$PORCELAIN_PROMPT_SYMBOL_STASH "
  fi

  # Git status: files with the assume-unchanged bit set

  if (( VCS_STATUS_NUM_ASSUME_UNCHANGED || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_ASSUME_UNCHANGED )) && p+="%${PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED}F$VCS_STATUS_NUM_ASSUME_UNCHANGED"
    p+="$PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED "
  fi

  # Git status: files with the skip-worktree bit set

  if (( VCS_STATUS_NUM_SKIP_WORKTREE || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_SKIP_WORKTREE )) && p+="%${PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE}F$VCS_STATUS_NUM_SKIP_WORKTREE"
    p+="$PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE "
  fi

  # Git status: unstaged added (new) files

  if (( VCS_STATUS_NUM_UNTRACKED || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_UNTRACKED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$VCS_STATUS_NUM_UNTRACKED" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_ADDED "
  fi

  # Git status: conflicted files

  if (( VCS_STATUS_NUM_CONFLICTED || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_CONFLICTED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$VCS_STATUS_NUM_CONFLICTED" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_CONFLICTED "
  fi

  # Git status: unstaged deleted files

  if (( VCS_STATUS_NUM_UNSTAGED_DELETED || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_UNSTAGED_DELETED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$VCS_STATUS_NUM_UNSTAGED_DELETED" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_DELETED "
  fi

  # Git status: unstaged modified files

  if (( unstaged_count || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( $unstaged_count )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}F$unstaged_count" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_MODIFIED "
  fi

  # Git status: staged added (new) files

  if (( VCS_STATUS_NUM_STAGED_NEW || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_STAGED_NEW )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}F$VCS_STATUS_NUM_STAGED_NEW" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED "
  fi

  # Git status: staged deleted files

  if (( VCS_STATUS_NUM_STAGED_DELETED || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( VCS_STATUS_NUM_STAGED_DELETED )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}F$VCS_STATUS_NUM_STAGED_DELETED" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED "
  fi

  # Git status: staged modified files

  if (( added_staged_count || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
    p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    (( added_staged_count )) && p+="%${PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}F$added_staged_count" && dirty=1
    p+="$PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED "
  fi

  # Git "where": colorize if Git status is dirty

  if (( dirty )); then
    w+="%${PORCELAIN_PROMPT_COLOR_WHERE}F"
  else
    w+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  fi

  # Git "where": committish
  #   If HEAD is detached (i.e. on a branch), show the branch.
  #     If the branch has an upstream, show how many commit behind and ahead the local is.
  #     If the upstream's remote is not the default, show it.
  #     If the upsteam has a different name from the local, show it.
  #     If both the upstream's branch and remote are shown, separate them with a slash (/)
  #   If HEAD is detached, show the commit.

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    w+="$PORCELAIN_PROMPT_SYMBOL_BRANCH$VCS_STATUS_LOCAL_BRANCH "

    w+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
    if [[ -z $VCS_STATUS_REMOTE_BRANCH ]]; then
      w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}Flocal "
    else
      if (( VCS_STATUS_COMMITS_BEHIND || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
        (( VCS_STATUS_COMMITS_BEHIND )) && w+="%${PORCELAIN_PROMPT_COLOR_WHERE}F$VCS_STATUS_COMMITS_BEHIND"
        w+="$PORCELAIN_PROMPT_SYMBOL_BEHIND "
      fi

      if (( VCS_STATUS_COMMITS_AHEAD || PORCELAIN_PROMPT_SHOW_INACTIVE )); then
        (( VCS_STATUS_COMMITS_AHEAD )) && w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}F$VCS_STATUS_COMMITS_AHEAD"
        w+="$PORCELAIN_PROMPT_SYMBOL_AHEAD "
      fi

      if [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
        w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}F${PORCELAIN_PROMPT_SYMBOL_BRANCH}${VCS_STATUS_REMOTE_BRANCH}"

        if (( not_default_remote )); then
          w+="/"
        fi
        w+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
      fi

      if (( not_default_remote )); then
        w+="%${PORCELAIN_PROMPT_COLOR_REMOTE}F$VCS_STATUS_REMOTE_NAME "
      fi
    fi
  else
    w+="$PORCELAIN_PROMPT_SYMBOL_COMMIT${VCS_STATUS_COMMIT[1,8]} "
  fi

  # Git "where": tag

  w+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  [[ -n $VCS_STATUS_TAG ]] && w+="%${PORCELAIN_PROMPT_COLOR_TAG}F$PORCELAIN_PROMPT_SYMBOL_TAG$VCS_STATUS_TAG "

  # Git "where": placement
  # If showing inline with directory, save for later use in prompt build;
  # otherwise add to the Git prompt

  if (( PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE )); then
    WHERE="${w}%f"
  else
    p+="$w"
  fi

  # Git status: action (e.g. rebasing)

  p+="%${PORCELAIN_PROMPT_COLOR_INACTIVE}F"
  [[ -n $VCS_STATUS_ACTION ]] && p+=" %${PORCELAIN_PROMPT_COLOR_ACTION}F$VCS_STATUS_ACTION"

  # Git: optionally prefix prompt
  (( PORCELAIN_PROMPT_HIDE_TOOL_NAMES )) || GITSTATUS_PROMPT+="Git "

  GITSTATUS_PROMPT+="${p}%f"
}

# Call to gitstatus external command

# Start gitstatusd instance with name "MY". The same name is passed to
# gitstatus_query in gitstatus_prompt_update. The flags with -1 as values
# enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

# On every prompt, fetch git status and set GITSTATUS_PROMPT.
autoload -Uz add-zsh-hook
add-zsh-hook precmd gitstatus_prompt_update

# Build the prompt

# Blank line

PROMPT=
PROMPT+=$'\n'

# User info
# Show user if not the default (has configurable color)
# Show host if not the default (has configurable color and prefix)

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

# Time

PROMPT+=$'%* '

# CWD (has configurable color, relative root, and depth)

PROMPT+='%F{$PORCELAIN_PROMPT_COLOR_CWD}$PORCELAIN_PROMPT_CWD%f'

# Git "where" if on same line as CWD

PROMPT+='${WHERE:+ $WHERE}'
PROMPT+=$'\n'

# Git status (includes "where" if not on same line as CWD)

PROMPT+='${GITSTATUS_PROMPT:+$GITSTATUS_PROMPT
}'

# Prompt character: % if normal, # if root (has configurable colors for status code of the previous command)

PROMPT+='%F{%(?.$PORCELAIN_PROMPT_COLOR_SUCCESS.$PORCELAIN_PROMPT_COLOR_FAIL)}%#%f '

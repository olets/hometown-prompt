# Porcelain Prompt
# https://github.com/olets/porcelain-prompt
# Copyright (section_context) 2019-2020 Henry Bley-Vroman
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
PORCELAIN_PROMPT_SET_PROMPT=${PORCELAIN_PROMPT_SET_PROMPT:-1}
PORCELAIN_PROMPT_SHOW_INACTIVE_CONTEXT=${PORCELAIN_PROMPT_SHOW_INACTIVE_CONTEXT:-1}
PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS=${PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS:-1}

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
PORCELAIN_PROMPT_SYMBOL_STASH=${PORCELAIN_PROMPT_SYMBOL_STASH-⇲}
PORCELAIN_PROMPT_SYMBOL_TAG=${PORCELAIN_PROMPT_SYMBOL_TAG:-}

# Configurable colors
# Use one of zsh's eight color names, or an integer 1-255 for an 8-bit color, or a #-prefixed RRGGBB value for 24-bit color.
# If using on single configuration dotfile across terminal emulators that may or may not support 24-bit color, add
# [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
# before setting the colors.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
# and http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fnearcolor-Module
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

function _porcelain_prompt_update_git() {
  emulate -L zsh
  typeset -g _PORCELAIN_PROMPT_GIT_STATUS=
  typeset -g _PORCELAIN_PROMPT_GIT_WHERE=

  # Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  # asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  # Set variables for later use
  # global _PORCELAIN_PROMPT_GIT_WHERE created conditionally later

  local added_staged_count
  local dirty=0
  local node_version=''
  local not_default_remote=0
  local section_action
  local section_context
  local section_status
  local section_where
  local unstaged_count

  (( added_staged_count = VCS_STATUS_NUM_STAGED - VCS_STATUS_NUM_STAGED_NEW - VCS_STATUS_NUM_STAGED_DELETED ))
  dirty=0
  node_version=''
  not_default_remote=0
  (( unstaged_count = VCS_STATUS_NUM_UNSTAGED - VCS_STATUS_NUM_UNSTAGED_DELETED ))

  if [[ $VCS_STATUS_REMOTE_NAME != $PORCELAIN_PROMPT_DEFAULT_REMOTE ]]; then
    not_default_remote=1
  fi

  # Git status: stashes

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_CONTEXT || VCS_STATUS_STASHES )); then
    section_context+="%F{PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_STASHES )) && section_context+="%F{$PORCELAIN_PROMPT_COLOR_STASH}$VCS_STATUS_STASHES"
    section_context+="$PORCELAIN_PROMPT_SYMBOL_STASH "
  fi

  # Git status: files with the assume-unchanged bit set

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_CONTEXT || VCS_STATUS_NUM_ASSUME_UNCHANGED )); then
    section_context+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_ASSUME_UNCHANGED )) && section_context+="%F{$PORCELAIN_PROMPT_COLOR_ASSUME_UNCHANGED}$VCS_STATUS_NUM_ASSUME_UNCHANGED"
    section_context+="$PORCELAIN_PROMPT_SYMBOL_ASSUME_UNCHANGED "
  fi

  # Git status: files with the skip-worktree bit set

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_CONTEXT || VCS_STATUS_NUM_SKIP_WORKTREE )); then
    section_context+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_SKIP_WORKTREE )) && section_context+="%F{$PORCELAIN_PROMPT_COLOR_SKIP_WORKTREE}$VCS_STATUS_NUM_SKIP_WORKTREE"
    section_context+="$PORCELAIN_PROMPT_SYMBOL_SKIP_WORKTREE "
  fi

  # Git status: unstaged added (new) files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_UNTRACKED )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_UNTRACKED )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}$VCS_STATUS_NUM_UNTRACKED" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_ADDED "
  fi

  # Git status: conflicted files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_CONFLICTED )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_CONFLICTED )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}$VCS_STATUS_NUM_CONFLICTED" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_CONFLICTED "
  fi

  # Git status: unstaged deleted files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_UNSTAGED_DELETED )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_UNSTAGED_DELETED )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}$VCS_STATUS_NUM_UNSTAGED_DELETED" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_DELETED "
  fi

  # Git status: unstaged modified files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || unstaged_count )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( $unstaged_count )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_UNSTAGED}$unstaged_count" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_MODIFIED "
  fi

  # Git status: staged added (new) files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_STAGED_NEW )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_STAGED_NEW )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}$VCS_STATUS_NUM_STAGED_NEW" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_ADDED_STAGED "
  fi

  # Git status: staged deleted files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_STAGED_DELETED )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_STAGED_DELETED )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}$VCS_STATUS_NUM_STAGED_DELETED" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_DELETED_STAGED "
  fi

  # Git status: staged modified files

  if (( PORCELAIN_PROMPT_SHOW_INACTIVE_STATUS || added_staged_count )); then
    section_status+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    (( added_staged_count )) && section_status+="%F{$PORCELAIN_PROMPT_COLOR_ACTIVE_STAGED}$added_staged_count" && dirty=1
    section_status+="$PORCELAIN_PROMPT_SYMBOL_MODIFIED_STAGED "
  fi

  # Git "where": colorize if Git status is dirty

  if (( dirty )); then
    section_where+="%F{$PORCELAIN_PROMPT_COLOR_WHERE}"
  else
    section_where+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
  fi

  # Git "where": committish
  #   If HEAD is detached (i.e. on a branch), show the branch.
  #     If the branch has an upstream, show how many commit behind and ahead the local is.
  #     If the upstream's remote is not the default, show it.
  #     If the upsteam has a different name from the local, show it.
  #     If both the upstream's branch and remote are shown, separate them with a slash (/)
  #   If HEAD is detached, show the commit.

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    section_where+="$PORCELAIN_PROMPT_SYMBOL_BRANCH$VCS_STATUS_LOCAL_BRANCH "

    section_where+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
    if [[ -z $VCS_STATUS_REMOTE_BRANCH ]]; then
      section_where+="%F{$PORCELAIN_PROMPT_COLOR_REMOTE}local "
    else
      if (( PORCELAIN_PROMPT_SHOW_INACTIVE || VCS_STATUS_COMMITS_BEHIND )); then
        (( VCS_STATUS_COMMITS_BEHIND )) && section_where+="%F{$PORCELAIN_PROMPT_COLOR_WHERE}$VCS_STATUS_COMMITS_BEHIND"
        section_where+="$PORCELAIN_PROMPT_SYMBOL_BEHIND "
      fi

      if (( PORCELAIN_PROMPT_SHOW_INACTIVE || VCS_STATUS_COMMITS_AHEAD )); then
        (( VCS_STATUS_COMMITS_AHEAD )) && section_where+="%F{$PORCELAIN_PROMPT_COLOR_REMOTE}$VCS_STATUS_COMMITS_AHEAD"
        section_where+="$PORCELAIN_PROMPT_SYMBOL_AHEAD "
      fi

      if [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
        section_where+="%F{$PORCELAIN_PROMPT_COLOR_REMOTE}${PORCELAIN_PROMPT_SYMBOL_BRANCH}${VCS_STATUS_REMOTE_BRANCH}"

        if (( not_default_remote )); then
          section_where+="/"
        fi
        section_where+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
      fi

      if (( not_default_remote )); then
        section_where+="%F{$PORCELAIN_PROMPT_COLOR_REMOTE}$VCS_STATUS_REMOTE_NAME "
      fi
    fi
  else
    section_where+="$PORCELAIN_PROMPT_SYMBOL_COMMIT${VCS_STATUS_COMMIT[1,8]} "
  fi

  # Git "where": tag

  section_where+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
  [[ -n $VCS_STATUS_TAG ]] && section_where+="%F{$PORCELAIN_PROMPT_COLOR_TAG}$PORCELAIN_PROMPT_SYMBOL_TAG$VCS_STATUS_TAG "

  # Git status: action (e.g. rebasing)

  section_action+="%F{$PORCELAIN_PROMPT_COLOR_INACTIVE}"
  [[ -n $VCS_STATUS_ACTION ]] && section_action+=" %F{$PORCELAIN_PROMPT_COLOR_ACTION}$VCS_STATUS_ACTION"

  # Assemble sections

  # Git "where": placement
  # If showing inline with directory, save for later use in prompt build;
  # otherwise add to the Git prompt

  if (( PORCELAIN_PROMPT_GIT_REF_ON_DIR_LINE )); then
    _PORCELAIN_PROMPT_GIT_STATUS+="$section_context$section_status$section_action%f"
    _PORCELAIN_PROMPT_GIT_WHERE="$section_where%f"
  else
    _PORCELAIN_PROMPT_GIT_STATUS+="$section_context$section_status$section_where$section_action%f"
  fi

  _PORCELAIN_PROMPT_GIT_STATUS+=$'\n'

  # Git: optionally prefix prompt

  (( PORCELAIN_PROMPT_HIDE_TOOL_NAMES )) || _PORCELAIN_PROMPT_GIT_STATUS+="Git $_PORCELAIN_PROMPT_GIT_STATUS"
}

_porcelain_prompt_build_prompt() {
  local prompt
  # Build the prompt

  # Blank line

  prompt=
  prompt+=$'\n'

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
    (( _porcelain_prompt_not_default_user )) && prompt+='%F{$PORCELAIN_PROMPT_COLOR_USER}%n$f'
    (( _porcelain_prompt_not_default_host )) && prompt+='%F{$PORCELAIN_PROMPT_COLOR_HOST}${PORCELAIN_PROMPT_SYMBOL_HOST}%m%f'
    prompt+=' '
  fi

  # Time

  prompt+=$'%* '

  # CWD (has configurable color, relative root, and depth)

  prompt+='%F{$PORCELAIN_PROMPT_COLOR_CWD}$PORCELAIN_PROMPT_CWD%f'

  # Git "where" if on same line as CWD

  prompt+='${_PORCELAIN_PROMPT_GIT_WHERE:+ $_PORCELAIN_PROMPT_GIT_WHERE}'
  prompt+=$'\n'

  # Git status (includes "where" if not on same line as CWD)

  prompt+='${_PORCELAIN_PROMPT_GIT_STATUS:+$_PORCELAIN_PROMPT_GIT_STATUS}'

  # Prompt character: % if normal, # if root (has configurable colors for status code of the previous command)

  prompt+='%F{%(?.$PORCELAIN_PROMPT_COLOR_SUCCESS.$PORCELAIN_PROMPT_COLOR_FAIL)}%#%f '
  echo $prompt
}

# Call to gitstatus external command

# Start gitstatusd instance with name "MY". The same name is passed to
# gitstatus_query in _porcelain_prompt_update_git. The flags with -1 as values
# enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

# On every prompt, fetch git status and set _PORCELAIN_PROMPT_GIT_STATUS.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _porcelain_prompt_update_git

(( PORCELAIN_PROMPT_SET_PROMPT )) && PROMPT=$(_porcelain_prompt_build_prompt)

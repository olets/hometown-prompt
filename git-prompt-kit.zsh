# Git Prompt Kit
# https://github.com/olets/git-prompt-kit
# Copyright (©) 2020 Henry Bley-Vroman
#
# Forked from and requires gitstatus prompt
# https://github.com/romkatv/gitstatus

# Configurable options
GIT_PROMPT_KIT_CUSTOM_CONTENT=${GIT_PROMPT_KIT_CUSTOM_CONTENT:-%2~} # see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Shell-state
GIT_PROMPT_KIT_DEFAULT_USER=${GIT_PROMPT_KIT_DEFAULT_USER-}
GIT_PROMPT_KIT_DEFAULT_HOST=${GIT_PROMPT_KIT_DEFAULT_HOST-}
GIT_PROMPT_KIT_DEFAULT_REMOTE=${GIT_PROMPT_KIT_DEFAULT_REMOTE:-origin}
GIT_PROMPT_KIT_GIT_REF_ON_NONGIT_LINE=${GIT_PROMPT_KIT_GIT_REF_ON_NONGIT_LINE:-1}
GIT_PROMPT_KIT_GIT_STATUS_ON_OWN_LINE=${GIT_PROMPT_KIT_GIT_STATUS_ON_OWN_LINE:-1}
GIT_PROMPT_KIT_HIDE_TOOL_NAMES=${GIT_PROMPT_KIT_HIDE_TOOL_NAMES:-1}
GIT_PROMPT_KIT_PROMPT_CHAR_NORMAL=${GIT_PROMPT_KIT_PROMPT_CHAR_NORMAL:-%}
GIT_PROMPT_KIT_PROMPT_CHAR_ROOT=${GIT_PROMPT_KIT_PROMPT_CHAR_ROOT:-#}
GIT_PROMPT_KIT_SHOW_INACTIVE_CONTEXT=${GIT_PROMPT_KIT_SHOW_INACTIVE_CONTEXT:-1}
GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS=${GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS:-1}
GIT_PROMPT_KIT_USE_DEFAULT_PROMPT=${GIT_PROMPT_KIT_USE_DEFAULT_PROMPT:-1}

# Configurable symbols
GIT_PROMPT_KIT_SYMBOL_AHEAD=${GIT_PROMPT_KIT_SYMBOL_AHEAD-↑}
GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED=${GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED-⥱ }
GIT_PROMPT_KIT_SYMBOL_BEHIND=${GIT_PROMPT_KIT_SYMBOL_BEHIND-↓}
GIT_PROMPT_KIT_SYMBOL_BRANCH=${GIT_PROMPT_KIT_SYMBOL_BRANCH-#}
GIT_PROMPT_KIT_SYMBOL_COMMIT=${GIT_PROMPT_KIT_SYMBOL_COMMIT-•}
GIT_PROMPT_KIT_SYMBOL_CONFLICTED=${GIT_PROMPT_KIT_SYMBOL_CONFLICTED-UU}
GIT_PROMPT_KIT_SYMBOL_DELETED=${GIT_PROMPT_KIT_SYMBOL_DELETED-_D}
GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED=${GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED-D_}
GIT_PROMPT_KIT_SYMBOL_HOST=${GIT_PROMPT_KIT_SYMBOL_HOST-@}
GIT_PROMPT_KIT_SYMBOL_MODIFIED=${GIT_PROMPT_KIT_SYMBOL_MODIFIED-_M}
GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED=${GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED-M_}
GIT_PROMPT_KIT_SYMBOL_NEW=${GIT_PROMPT_KIT_SYMBOL_NEW-A_}
GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE=${GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE-⤳ }
GIT_PROMPT_KIT_SYMBOL_STASH=${GIT_PROMPT_KIT_SYMBOL_STASH-⇲}
GIT_PROMPT_KIT_SYMBOL_TAG=${GIT_PROMPT_KIT_SYMBOL_TAG-@}
GIT_PROMPT_KIT_SYMBOL_UNTRACKED=${GIT_PROMPT_KIT_SYMBOL_UNTRACKED-??}

# Configurable colors
# Use one of zsh's eight color names, or an integer 1-255 for an 8-bit color, or a #-prefixed RRGGBB value for 24-bit color.
# If using on single configuration dotfile across terminal emulators that may or may not support 24-bit color, add
# [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
# before setting the colors.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
# and http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fnearcolor-Module
GIT_PROMPT_KIT_COLOR_ACTION=${GIT_PROMPT_KIT_COLOR_ACTION:-199}
GIT_PROMPT_KIT_COLOR_STAGED=${GIT_PROMPT_KIT_COLOR_STAGED:-2}
GIT_PROMPT_KIT_COLOR_UNSTAGED=${GIT_PROMPT_KIT_COLOR_UNSTAGED:-1}
GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED=${GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED:-81}
GIT_PROMPT_KIT_COLOR_CUSTOM=${GIT_PROMPT_KIT_COLOR_CUSTOM:-39}
GIT_PROMPT_KIT_COLOR_FAILED=${GIT_PROMPT_KIT_COLOR_FAILED:-196}
GIT_PROMPT_KIT_COLOR_HOST=${GIT_PROMPT_KIT_COLOR_HOST:-109}
GIT_PROMPT_KIT_COLOR_INACTIVE=${GIT_PROMPT_KIT_COLOR_INACTIVE:-248}
GIT_PROMPT_KIT_COLOR_REMOTE=${GIT_PROMPT_KIT_COLOR_REMOTE:-216}
GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE=${GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE:-81}
GIT_PROMPT_KIT_COLOR_STASH=${GIT_PROMPT_KIT_COLOR_STASH:-81}
GIT_PROMPT_KIT_COLOR_SUCCEEDED=${GIT_PROMPT_KIT_COLOR_SUCCEEDED:-76}
GIT_PROMPT_KIT_COLOR_TAG=${GIT_PROMPT_KIT_COLOR_TAG:-140}
GIT_PROMPT_KIT_COLOR_USER=${GIT_PROMPT_KIT_COLOR_USER:-109}
GIT_PROMPT_KIT_COLOR_HEAD=${GIT_PROMPT_KIT_COLOR_HEAD:-140}

function _git_prompt_kit_update_git() {
  emulate -L zsh
  typeset -g _GIT_PROMPT_KIT_GIT_SECOND_LINE=
  typeset -g _GIT_PROMPT_KIT_GIT_FIRST_LINE=
  typeset -g _GIT_PROMPT_KIT_GIT_THIRD_LINE=

  # Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  # asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  # Set variables for later use

  local action_status=
  local added_staged_count=
  local dirty=0
  local not_default_remote=0
  local ref_status=
  local tree_status=
  local unstaged_count=

  typeset -g GIT_PROMPT_KIT_STASHES=
  typeset -g GIT_PROMPT_KIT_ASSUMED_UNCHANGED=
  typeset -g GIT_PROMPT_KIT_SKIP_WORKTREE=
  typeset -g GIT_PROMPT_KIT_UNTRACKED=
  typeset -g GIT_PROMPT_KIT_CONFLICTED=
  typeset -g GIT_PROMPT_KIT_DELETED=
  typeset -g GIT_PROMPT_KIT_MODIFIED=
  typeset -g GIT_PROMPT_KIT_NEW=
  typeset -g GIT_PROMPT_KIT_DELETED_STAGED=
  typeset -g GIT_PROMPT_KIT_MODIFIED_STAGED=
  typeset -g GIT_PROMPT_KIT_HEAD=
  typeset -g GIT_PROMPT_KIT_UPSTREAM=
  typeset -g GIT_PROMPT_KIT_BEHIND=
  typeset -g GIT_PROMPT_KIT_AHEAD=
  typeset -g GIT_PROMPT_KIT_TAG=
  typeset -g GIT_PROMPT_KIT_ACTION=

  (( added_staged_count = VCS_STATUS_NUM_STAGED - VCS_STATUS_NUM_STAGED_NEW - VCS_STATUS_NUM_STAGED_DELETED ))
  (( unstaged_count = VCS_STATUS_NUM_UNSTAGED - VCS_STATUS_NUM_UNSTAGED_DELETED ))

  if [[ $VCS_STATUS_REMOTE_NAME != $GIT_PROMPT_KIT_DEFAULT_REMOTE ]]; then
    not_default_remote=1
  fi

  # Git tree status: stashes

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_CONTEXT || VCS_STATUS_STASHES )); then
    GIT_PROMPT_KIT_STASHES+="%F{GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_STASHES )) && GIT_PROMPT_KIT_STASHES+="%F{$GIT_PROMPT_KIT_COLOR_STASH}$VCS_STATUS_STASHES"
    GIT_PROMPT_KIT_STASHES+="$GIT_PROMPT_KIT_SYMBOL_STASH"
  fi

  # Git tree status: files with the assume-unchanged bit set

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_CONTEXT || VCS_STATUS_NUM_ASSUME_UNCHANGED )); then
    GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_ASSUME_UNCHANGED )) && GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="%F{$GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED}$VCS_STATUS_NUM_ASSUME_UNCHANGED"
    GIT_PROMPT_KIT_ASSUMED_UNCHANGED+="$GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED"
  fi

  # Git tree status: files with the skip-worktree bit set

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_CONTEXT || VCS_STATUS_NUM_SKIP_WORKTREE )); then
    GIT_PROMPT_KIT_SKIP_WORKTREE+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_SKIP_WORKTREE )) && GIT_PROMPT_KIT_SKIP_WORKTREE+="%F{$GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE}$VCS_STATUS_NUM_SKIP_WORKTREE"
    GIT_PROMPT_KIT_SKIP_WORKTREE+="$GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE"
  fi

  # Git tree status: untracked (new) files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_UNTRACKED )); then
    GIT_PROMPT_KIT_UNTRACKED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_UNTRACKED )) && GIT_PROMPT_KIT_UNTRACKED+="%F{$GIT_PROMPT_KIT_COLOR_UNSTAGED}$VCS_STATUS_NUM_UNTRACKED" && dirty=1
    GIT_PROMPT_KIT_UNTRACKED+="$GIT_PROMPT_KIT_SYMBOL_UNTRACKED"
  fi

  # Git tree status: conflicted files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_CONFLICTED )); then
    GIT_PROMPT_KIT_CONFLICTED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_CONFLICTED )) && GIT_PROMPT_KIT_CONFLICTED+="%F{$GIT_PROMPT_KIT_COLOR_UNSTAGED}$VCS_STATUS_NUM_CONFLICTED" && dirty=1
    GIT_PROMPT_KIT_CONFLICTED+="$GIT_PROMPT_KIT_SYMBOL_CONFLICTED"
  fi

  # Git tree status: unstaged deleted files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_UNSTAGED_DELETED )); then
    GIT_PROMPT_KIT_DELETED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_UNSTAGED_DELETED )) && GIT_PROMPT_KIT_DELETED+="%F{$GIT_PROMPT_KIT_COLOR_UNSTAGED}$VCS_STATUS_NUM_UNSTAGED_DELETED" && dirty=1
    GIT_PROMPT_KIT_DELETED+="$GIT_PROMPT_KIT_SYMBOL_DELETED"
  fi

  # Git tree status: unstaged modified files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || unstaged_count )); then
    GIT_PROMPT_KIT_MODIFIED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( $unstaged_count )) && GIT_PROMPT_KIT_MODIFIED+="%F{$GIT_PROMPT_KIT_COLOR_UNSTAGED}$unstaged_count" && dirty=1
    GIT_PROMPT_KIT_MODIFIED+="$GIT_PROMPT_KIT_SYMBOL_MODIFIED"
  fi

  # Git tree status: staged new files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_STAGED_NEW )); then
    GIT_PROMPT_KIT_NEW+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_STAGED_NEW )) && GIT_PROMPT_KIT_NEW+="%F{$GIT_PROMPT_KIT_COLOR_STAGED}$VCS_STATUS_NUM_STAGED_NEW" && dirty=1
    GIT_PROMPT_KIT_NEW+="$GIT_PROMPT_KIT_SYMBOL_NEW"
  fi

  # Git tree status: staged deleted files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_NUM_STAGED_DELETED )); then
    GIT_PROMPT_KIT_DELETED_STAGED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( VCS_STATUS_NUM_STAGED_DELETED )) && GIT_PROMPT_KIT_DELETED_STAGED+="%F{$GIT_PROMPT_KIT_COLOR_STAGED}$VCS_STATUS_NUM_STAGED_DELETED" && dirty=1
    GIT_PROMPT_KIT_DELETED_STAGED+="$GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED"
  fi

  # Git tree status: staged modified files

  if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || added_staged_count )); then
    GIT_PROMPT_KIT_MODIFIED_STAGED+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    (( added_staged_count )) && GIT_PROMPT_KIT_MODIFIED_STAGED+="%F{$GIT_PROMPT_KIT_COLOR_STAGED}$added_staged_count" && dirty=1
    GIT_PROMPT_KIT_MODIFIED_STAGED+="$GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED"
  fi

  # Git ref status: colorize if Git status is dirty

  if (( dirty )); then
    GIT_PROMPT_KIT_HEAD+="%F{$GIT_PROMPT_KIT_COLOR_HEAD}"
  else
    GIT_PROMPT_KIT_HEAD+="%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
  fi

  # Git ref status:
  #   If HEAD is detached (i.e. on a branch), show the branch.
  #     If the branch has an upstream, show how many commit behind and ahead the local is.
  #     If the upstream's remote is not the default, show it.
  #     If the upsteam has a different name from the local, show it.
  #     If both the upstream's branch and remote are shown, separate them with a slash (/)
  #   If HEAD is detached, show the commit.

  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    GIT_PROMPT_KIT_HEAD+="$GIT_PROMPT_KIT_SYMBOL_BRANCH$VCS_STATUS_LOCAL_BRANCH%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"

    if [[ -z $VCS_STATUS_REMOTE_BRANCH ]]; then
      GIT_PROMPT_KIT_UPSTREAM+="%F{$GIT_PROMPT_KIT_COLOR_REMOTE}local%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
    else
      if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_COMMITS_BEHIND )); then
        (( VCS_STATUS_COMMITS_BEHIND )) && GIT_PROMPT_KIT_BEHIND+="%F{$GIT_PROMPT_KIT_COLOR_HEAD}$VCS_STATUS_COMMITS_BEHIND"
        GIT_PROMPT_KIT_BEHIND+="$GIT_PROMPT_KIT_SYMBOL_BEHIND%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
      fi

      if (( GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS || VCS_STATUS_COMMITS_AHEAD )); then
        (( VCS_STATUS_COMMITS_AHEAD )) && GIT_PROMPT_KIT_AHEAD+="%F{$GIT_PROMPT_KIT_COLOR_REMOTE}$VCS_STATUS_COMMITS_AHEAD"
        GIT_PROMPT_KIT_AHEAD+="$GIT_PROMPT_KIT_SYMBOL_AHEAD%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
      fi

      if (( not_default_remote )); then
        GIT_PROMPT_KIT_UPSTREAM+="%F{$GIT_PROMPT_KIT_COLOR_REMOTE}$VCS_STATUS_REMOTE_NAME/%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
      fi

      if (( not_default_remote )) || [[ $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
        GIT_PROMPT_KIT_UPSTREAM+="%F{$GIT_PROMPT_KIT_COLOR_REMOTE}${GIT_PROMPT_KIT_SYMBOL_BRANCH}${VCS_STATUS_REMOTE_BRANCH}%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
      fi
    fi
  else
    GIT_PROMPT_KIT_HEAD+="$GIT_PROMPT_KIT_SYMBOL_COMMIT${VCS_STATUS_COMMIT[1,8]}%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"
  fi

  # Git ref status: tag

  [[ -n $VCS_STATUS_TAG ]] && GIT_PROMPT_KIT_TAG+="%F{$GIT_PROMPT_KIT_COLOR_TAG}$GIT_PROMPT_KIT_SYMBOL_TAG$VCS_STATUS_TAG%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"

  # Git status: action_status (e.g. rebasing)

  [[ -n $VCS_STATUS_ACTION ]] && GIT_PROMPT_KIT_ACTION+="%F{$GIT_PROMPT_KIT_COLOR_ACTION}$VCS_STATUS_ACTION%F{$GIT_PROMPT_KIT_COLOR_INACTIVE}"

  if (( GIT_PROMPT_KIT_USE_DEFAULT_PROMPT )); then
    # If setting the prompt, assemble sections

    action_status+="${GIT_PROMPT_KIT_ACTION:+$GIT_PROMPT_KIT_ACTION}"

    tree_status+="${GIT_PROMPT_KIT_STASHES:+$GIT_PROMPT_KIT_STASHES }"
    tree_status+="${GIT_PROMPT_KIT_ASSUMED_UNCHANGED:+$GIT_PROMPT_KIT_ASSUMED_UNCHANGED }"
    tree_status+="${GIT_PROMPT_KIT_SKIP_WORKTREE:+$GIT_PROMPT_KIT_SKIP_WORKTREE }"
    tree_status+="${GIT_PROMPT_KIT_UNTRACKED:+$GIT_PROMPT_KIT_UNTRACKED }"
    tree_status+="${GIT_PROMPT_KIT_CONFLICTED:+$GIT_PROMPT_KIT_CONFLICTED }"
    tree_status+="${GIT_PROMPT_KIT_DELETED:+$GIT_PROMPT_KIT_DELETED }"
    tree_status+="${GIT_PROMPT_KIT_MODIFIED:+$GIT_PROMPT_KIT_MODIFIED }"
    tree_status+="${GIT_PROMPT_KIT_NEW:+$GIT_PROMPT_KIT_NEW }"
    tree_status+="${GIT_PROMPT_KIT_DELETED_STAGED:+$GIT_PROMPT_KIT_DELETED_STAGED }"
    tree_status+="${GIT_PROMPT_KIT_MODIFIED_STAGED:+$GIT_PROMPT_KIT_MODIFIED_STAGED }"

    ref_status+="${GIT_PROMPT_KIT_HEAD:+$GIT_PROMPT_KIT_HEAD }"
    ref_status+="${GIT_PROMPT_KIT_BEHIND:+$GIT_PROMPT_KIT_BEHIND }"
    ref_status+="${GIT_PROMPT_KIT_AHEAD:+$GIT_PROMPT_KIT_AHEAD }"
    ref_status+="${GIT_PROMPT_KIT_UPSTREAM:+$GIT_PROMPT_KIT_UPSTREAM }"
    ref_status+="${GIT_PROMPT_KIT_TAG:+$GIT_PROMPT_KIT_TAG}"

    # Git: optionally prefix prompt

    (( GIT_PROMPT_KIT_HIDE_TOOL_NAMES )) || ref_status="Git $ref_status"

    if ! (( GIT_PROMPT_KIT_GIT_STATUS_ON_OWN_LINE )); then
      ref_status+="$tree_status"
      ref_status+="$action_status%f"
    fi

    if (( GIT_PROMPT_KIT_GIT_REF_ON_NONGIT_LINE )); then
      _GIT_PROMPT_KIT_GIT_FIRST_LINE=$ref_status
    else
      _GIT_PROMPT_KIT_GIT_FIRST_LINE+=$'\n'
      _GIT_PROMPT_KIT_GIT_SECOND_LINE=$ref_status
    fi


    if (( GIT_PROMPT_KIT_GIT_STATUS_ON_OWN_LINE )); then
      _GIT_PROMPT_KIT_GIT_SECOND_LINE+=$'\n'
      _GIT_PROMPT_KIT_GIT_THIRD_LINE+="$tree_status"
      _GIT_PROMPT_KIT_GIT_THIRD_LINE+="$action_status%f"
    fi
  fi
}

_git_prompt_kit_update_nongit() {
  local git_prompt_kit_not_default_user=0
  local git_prompt_kit_not_default_host=0

  typeset -g GIT_PROMPT_KIT_CUSTOM="%F{$GIT_PROMPT_KIT_COLOR_CUSTOM}$GIT_PROMPT_KIT_CUSTOM_CONTENT%f"

  # Prompt character: % if normal, # if root (has configurable colors for status code of the previous command)
  typeset -g GIT_PROMPT_KIT_CHAR="%F{%(?.$GIT_PROMPT_KIT_COLOR_SUCCEEDED.$GIT_PROMPT_KIT_COLOR_FAILED)}$GIT_PROMPT_KIT_PROMPT_CHAR_NORMAL$GIT_PROMPT_KIT_PROMPT_CHAR_ROOT%f"

  # User info
  # Show user if not the default (has configurable color)
  # Show host if not the default (has configurable color and prefix)
  typeset -g GIT_PROMPT_KIT_USERHOST=
  if [[ ${(%):-%n} != $GIT_PROMPT_KIT_DEFAULT_USER ]]; then
    _git_prompt_kit_not_default_user=1
  fi

  if [[ ${(%):-%m} != $GIT_PROMPT_KIT_DEFAULT_HOST ]]; then
    _git_prompt_kit_not_default_host=1
  fi

  if (( _git_prompt_kit_not_default_user || _git_prompt_kit_not_default_host )); then
    (( _git_prompt_kit_not_default_user )) && GIT_PROMPT_KIT_USERHOST+="%F{$GIT_PROMPT_KIT_COLOR_USER}%n$f"
    (( _git_prompt_kit_not_default_host )) && GIT_PROMPT_KIT_USERHOST+="%F{$GIT_PROMPT_KIT_COLOR_HOST}${GIT_PROMPT_KIT_SYMBOL_HOST}%m%f"
  fi
}

_git_prompt_kit_build_prompt() {
  local prompt=

  # Black line after result of previous commad
  prompt+=$'\n'

  # User and host
  prompt+='${GIT_PROMPT_KIT_USERHOST:+GIT_PROMPT_KIT_USERHOST }'

  # Time
  prompt+=$'%* '

  # Custom (CWD by default)
  prompt+='$GIT_PROMPT_KIT_CUSTOM'

  # Git
  prompt+='${_GIT_PROMPT_KIT_GIT_FIRST_LINE:+ $_GIT_PROMPT_KIT_GIT_FIRST_LINE}'
  prompt+='${_GIT_PROMPT_KIT_GIT_SECOND_LINE:+$_GIT_PROMPT_KIT_GIT_SECOND_LINE}'
  prompt+='${_GIT_PROMPT_KIT_GIT_THIRD_LINE:+$_GIT_PROMPT_KIT_GIT_THIRD_LINE}'

  # Prompt character
  prompt+=$'\n'
  prompt+='${GIT_PROMPT_KIT_CHAR:+$GIT_PROMPT_KIT_CHAR }'

  echo $prompt
}

# Start gitstatusd instance with name "MY". The same name is passed to
# gitstatus_query in _git_prompt_kit_update_git. The flags with -1 as values
# enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

# On every prompt, refresh prompt content
autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_prompt_kit_update_git
add-zsh-hook precmd _git_prompt_kit_update_nongit

# If setting the prompt, set it.
(( GIT_PROMPT_KIT_USE_DEFAULT_PROMPT )) && PROMPT=$(_git_prompt_kit_build_prompt)

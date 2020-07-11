# Git Prompt Kit ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/git-prompt-kit)

**Git Prompt Kit** is a configurable set of components for creating feature rich, high performance Git-aware zsh prompts (aka themes) with minimal coding. It is built on gitstatus, the same accelerated `git status` alternative used by Powerlevel10k.

Git Prompt Kit comes with a **default prompt** with segments for the user, host, time, the current working directory and its parent, and detailed full Git status with in a Git repo. With the default configuration it looks like

![](./img/git-prompt-kit-default.jpg)

Get a feel for how the components respond to context and how the options work by playing with the default prompt at https://codepen.io/henry/pen/oNjGxKP

&nbsp;

- [Installation](#installation)
- [Default prompt](#default-prompt)
- [Options](#options)
- [Components](#components)
- [Performance](#performance)
- [Acknowledgments](#acknowledgments)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [License](#license)

&nbsp;

## Installation

### Installing with a package manager

Git Prompt Kit is available on Homebrew. Run

```
brew install olets/tap/git-prompt-kit
```

and follow the post-install instructions logged to the terminal.

### Installing with a plugin manager

Or install Git Prompt Kit with your favorite plugin manager (zinit is recommended for its superior performance).

- **[antibody](https://getantibody.github.io/)**: Add this to your plugins to your plugins file, and if you use static loading reload plugins.
  ```shell
  olets/git-prompt-kit
  ```

- **[Antigen](https://github.com/zsh-users/antigen)**: Add this to your `.zshrc`:
  ```shell
  antigen bundle olets/git-prompt-kit
  ```

- **[Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)**:

  - Clone to OMZ's plugins' directory:

    ```shell
    git clone https://github.com/olets/git-prompt-kit.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-prompt-kit
    ```

  - Add to the OMZ plugins array in your `.zshrc`:

    ```shell
    plugins=( [plugins...] git-prompt-kit)
    ```

- **[zgen](https://github.com/tarjoilija/zgen)**: add this to your `.zshrc`:
  ```shell
  zgen load olets/git-prompt-kit
  ```

- **[zinit](https://github.com/zdharma/zinit)** (formerly **zplugin**): add this to your `.zshrc`:
  ```shell
  zinit light olets/git-prompt-kit
  ```

- **[zplug](https://github.com/zplug/zplug)**: add this to your `.zshrc`:
  ```shell
  zplug "olets/git-prompt-kit"
  ```

### Installing with a prompt manager

Git Prompt Kit comes with a [Spaceship](https://github.com/denysdovhan/spaceship-prompt) section definition, and it is easy to create a [Starship](https://starship.rs/) custom Git Prompt Kit-powered Git module. Instructions for both are in [Recipes.md](Recipes.md).

The Git Prompt Kit Spaceship section has been clocked at 50% faster than Spaceship's own Git section. The Git Prompt Kit Starship module has been clocked at about 10% to 30% faster than Starship's own Git module.

## Default prompt

Try out the default prompt at https://codepen.io/henry/pen/oNjGxKP.

Conceptually it is

```
<time> <CWD and parent> <branch or commit> <commits ahead> <commits behind> <upstream (branch if different name, remote and branch if not default remote, "local" if none)> <tag>
<stashes> <assumed-unchanged files> <skip-worktree files> <untracked files> <conflicted files> <deleted files> <modified files> <new files> <staged deleted files> <staged modified files> <action>
```

The current working directory can be replaced with any arbitrary content.

In the above screenshot, the default Git Prompt Kit prompt shows that `main` is checked out and dirty; that it is one commit ahead of the remote tracking branch; that there are three stashes, no untracked files, no conflicted files, no unstaged deleted files, one unstaged modified file, no staged new files, no staged deleted files, and one staged modified file; that the previous command succeeded, and that the user is not root; and, implicitly, that neither the user or host is unexpected, that the remote tracking branch is `origin/main`, that the local branch is not behind it, that there is no tag at `HEAD`, no file with the assume-unchanged bit set, no file with the skip-worktree bit set, and no action (e.g. merge, rebase, cherry-pick) underway.

## Options

Set variables in `.zshrc` above the point where Git Prompt Kit is loaded. For example, to only show the user if _not_ `me`, only show the host if _not_ `my-computer` or `my-other-computer`, and use symbols to distinguish between branches and commits:

```shell
# ~/.zshrc
# --- snip ---
typeset -a GIT_PROMPT_KIT_HIDDEN_HOSTS=(my-computer my-other-computer)
typeset -a GIT_PROMPT_KIT_HIDDEN_USERS=(me)
GIT_PROMPT_KIT_SYMBOL_BRANCH="#"
GIT_PROMPT_KIT_SYMBOL_COMMIT="•"
zinit light olets/git-prompt-kit
```

To output your configuration, for example for sharing, run

```shell
git-prompt-kit-config
```

(The exporter makes an effort to get quoting right, but if `GIT_PROMPT_KIT_CUSTOM_CONTENT` has been customized and includes quotations it's worth double checking that the exported value is correct.)

### Behavior options

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_HIDE_INACTIVE_AHEAD_BEHIND` | number | Hide dimmed symbols for the commits ahead of and commits behind the upstream branch when the count is zero? (YES if non-zero, NO if zero) | `1`
`GIT_PROMPT_KIT_HIDE_INACTIVE_EXTENDED_STATUS` | number | Hide dimmed Git stash, assumed-unchanged, and skip-worktree symbols when the count is zero? (YES if non-zero, NO if zero) | `1`
`GIT_PROMPT_KIT_HIDE_TOOL_NAMES` | number | Do not show the word "Git" before the Git ref info? (YES if non-zero, NO if zero) | `1`
`GIT_PROMPT_KIT_SHOW_INACTIVE_STATUS` | number | Show Git status symbols (dimmed) when the count is zero? (YES if non-zero, NO if zero) | `1`
`GIT_PROMPT_KIT_USE_DEFAULT_PROMPT` | number | Use the default Git Prompt Kit prompt? (YES if non-zero, NO if zero) | `1`

### Color options

Colors can be one of zsh's eight color names (`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan` and `white`; see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting), an integer 1-255 for an 8-bit color (see https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit), or a #-prefixed 3- or 6-character hexadecimal value for 24-bit color (e.g. `#fff`, `#34d5eb`). Support varies by terminal emulator.

For the default colors' table but with swatches, see [Issue #1: README appendix: default colors' swatches](https://github.com/olets/git-prompt-kit/issues/1). Note that the may appear differently in your terminal. To see visualize the configured colors in your terminal, run

```shell
git-prompt-kit-colors
```

To check a color it can be useful to run `print -P %F{<color>}<text>%f`, for example `print -P %F{199}●%f`.

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_COLOR_ACTION` | string | Color of the Git action segment | `199`
`GIT_PROMPT_KIT_COLOR_ASSUME_UNCHANGED` | string | Color of the Git assumed unchaged files segment | `81`
`GIT_PROMPT_KIT_COLOR_CUSTOM` | string | Color of the custom segment (CWD in the default prompt) | `39`
`GIT_PROMPT_KIT_COLOR_FAILED` | string | Color of the prompt character when the previous command failed | `88`
`GIT_PROMPT_KIT_COLOR_HEAD` | string | Color of the Git HEAD segment when the working tree is dirty | `140`
`GIT_PROMPT_KIT_COLOR_HOST` | string | Color of the host segment | `109`
`GIT_PROMPT_KIT_COLOR_INACTIVE` | string | Color of inactive segments | `247`
`GIT_PROMPT_KIT_COLOR_REMOTE` | string | Color of the Git remote and the commits-ahead files segment | `216`
`GIT_PROMPT_KIT_COLOR_SKIP_WORKTREE` | string | Color of the Git skip-worktree files segment | `81`
`GIT_PROMPT_KIT_COLOR_STAGED` | string | Color of Git staged files segment  | `120`
`GIT_PROMPT_KIT_COLOR_STASH` | string | Color of the Git stashes segment | `81`
`GIT_PROMPT_KIT_COLOR_SUCCEEDED` | string | Color of the prompt character when the previous command succeeded | `76`
`GIT_PROMPT_KIT_COLOR_TAG` | string | Color of Git tag segment | `86`
`GIT_PROMPT_KIT_COLOR_UNSTAGED` | string | Color of Git unstaged files segment | `162`
`GIT_PROMPT_KIT_COLOR_USER` | string | Color of the user | `109`

### Content options

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_CUSTOM_CONTENT` | string | The code for the custom component* | `%2~`**
`GIT_PROMPT_KIT_DEFAULT_REMOTE` | string | The default Git remote | `origin`
`GIT_PROMPT_KIT_HIDDEN_HOSTS` | array | The hosts that will not be included in the prompt | `()`
`GIT_PROMPT_KIT_HIDDEN_USERS` | array | The users that will not be included in the prompt | `()`
`GIT_PROMPT_KIT_LOCAL` | string | Shown if the checked-out branch has no upstream | `local`
`GIT_PROMPT_KIT_SHOW_EXTENDED_STATUS` | number | Show the stash, assume-unchanged, and skip-worktree counts (YES if non-zero, NO if zero) | `1`

\* For the special sequences supported in zsh prompts see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
\** Current working directory and its parent, with `~` for initial `$HOME` (and with custom zsh "named directories" respected; see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Shell-state) (use `print -P <string>` to check a prompt string, e.g. `print -P "%2~"`).

### Layout options

"Git ref segment" is HEAD, commits ahead/behind, upstream, and tag.

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_LINEBREAK_AFTER_GIT_REF` | number | _Do_ add a line break after the Git ref segment? (YES if non-zero, NO if zero) | `1`
`GIT_PROMPT_KIT_NO_LINEBREAK_BEFORE_GIT_REF` | number | Do _not_ add a line break before the Git ref segment? (YES if non-zero, NO if zero) | `1`

### Symbol options

The default symbols should work well in any font. The default Git file status symbols are [Git's own short format](https://git-scm.com/docs/git-status#_short_format) (underscore `_` represents column placement in `git-status --short`'s output).

Name | Type | Description | Default
---|---|---|---
`GIT_PROMPT_KIT_SYMBOL_AHEAD` | string | Precedes the Git commits-ahead segment | `+`
`GIT_PROMPT_KIT_SYMBOL_ASSUME_UNCHANGED` | string | Follows the Git assume-unchanged segment | `⥱ `
`GIT_PROMPT_KIT_SYMBOL_BEHIND` | string | Precedes the Git commits-behind segment | `-`
`GIT_PROMPT_KIT_SYMBOL_BRANCH` | string | Precedes the Git branch | none
`GIT_PROMPT_KIT_SYMBOL_CHAR_NORMAL` | string | Character shown at end of prompt for normal users | `%%` ***
`GIT_PROMPT_KIT_SYMBOL_CHAR_ROOT` | string | Character shown at end of prompt for root users | `#`
`GIT_PROMPT_KIT_SYMBOL_COMMIT` | string | Precedes the Git commit | none
`GIT_PROMPT_KIT_SYMBOL_CONFLICTED` | string | Follows the Git conflicted files segment | `UU`
`GIT_PROMPT_KIT_SYMBOL_DELETED_STAGED` | string | Follows the Git unstaged deleted file segment | `D_`
`GIT_PROMPT_KIT_SYMBOL_DELETED` | string | Follows the Git unstaged deleted file segment | `_D`
`GIT_PROMPT_KIT_SYMBOL_HOST` | string | Precedes the host | `@`
`GIT_PROMPT_KIT_SYMBOL_MODIFIED_STAGED` | string | Follows the Git staged modified file segment | `M_`
`GIT_PROMPT_KIT_SYMBOL_MODIFIED` | string | Follows the Git unstaged modified file segment | `_M`
`GIT_PROMPT_KIT_SYMBOL_NEW` | string | Follows Git new file segment | `A_`
`GIT_PROMPT_KIT_SYMBOL_SKIP_WORKTREE` | string | Follows the Git skip-worktree file segment | `⤳ `
`GIT_PROMPT_KIT_SYMBOL_STASH` | string | Follows the Git stash segment | `⇲`
`GIT_PROMPT_KIT_SYMBOL_TAG` | string | Precedes the Git tag | `@`
`GIT_PROMPT_KIT_SYMBOL_UNTRACKED` | string | Follows Git untracked file segment | `??`

\*** `%%` expands as `%` in the zsh prompt.

## Components

To use Git Prompt Kit's components in a custom prompt, set `GIT_PROMPT_KIT_USE_DEFAULT_PROMPT` to `0` before loading Git Prompt Kit, load Git Prompt Kit, and then refer to any of its components.

For example, for the prompt `<current working directory> [<Git HEAD> ]% `:

```shell
# ~/.zshrc
# --- snip ---
GIT_PROMPT_KIT_USE_DEFAULT_PROMPT=0
zinit light olets/git-prompt-kit
PROMPT='%1d ${GIT_PROMPT_KIT_HEAD:+$GIT_PROMPT_KIT_HEAD }%% '
```

Code samples that use Git Prompt Kit components to build high-performance prompts styled after [git-radar](https://github.com/michaeldfallen/git-radar), [oh-my-git](https://github.com/arialdomartini/oh-my-git), [Pure](https://github.com/sindresorhus/pure), and [Spaceship](https://github.com/denysdovhan/spaceship-prompt) are provided in [Recipes.md](Recipes.md).

The Git Prompt Kit default prompt is equivalent to

```shell
$GIT_PROMPT_KIT_REF${GIT_PROMPT_KIT_SHOW_EXTENDED_STATUS:+$GIT_PROMPT_KIT_STATUS_EXTENDED}${${GIT_PROMPT_KIT_SHOW_EXTENDED_STATUS:+$GIT_PROMPT_KIT_STATUS_EXTENDED}:+${${GIT_PROMPT_KIT_STATUS:-$GIT_PROMPT_KIT_ACTION}:+ }}$GIT_PROMPT_KIT_STATUS${GIT_PROMPT_KIT_STATUS:+${GIT_PROMPT_KIT_ACTION:+ }}$GIT_PROMPT_KIT_ACTION
```

### Atom components

Name | Type | Description
---|---|---
`GIT_PROMPT_KIT_ACTION` | prompt string | Git: current action (e.g. "rebase")
`GIT_PROMPT_KIT_AHEAD` | prompt string | Git: commits ahead of the upstream
`GIT_PROMPT_KIT_ASSUMED_UNCHANGED` | prompt string | Git: assume-unchanged files
`GIT_PROMPT_KIT_BEHIND` | prompt string | Git: commits behind the upstream
`GIT_PROMPT_KIT_CHAR` | prompt string | Prompt character
`GIT_PROMPT_KIT_CONFLICTED` | prompt string | Git: conflicted files
`GIT_PROMPT_KIT_CUSTOM` | prompt string | Custom (current working directory by default, see Content Options)
`GIT_PROMPT_KIT_DELETED_STAGED` | prompt string | Git: staged deleted files
`GIT_PROMPT_KIT_DELETED` | prompt string | Git: unstaged deleted files
`GIT_PROMPT_KIT_HEAD` | prompt string | Git: HEAD (branch or commit)
`GIT_PROMPT_KIT_MODIFIED_STAGED` | prompt string | Git: staged modified files
`GIT_PROMPT_KIT_MODIFIED` | prompt string | Git: unstaged modified files
`GIT_PROMPT_KIT_NEW` | prompt string | Git: (staged) new files
`GIT_PROMPT_KIT_SKIP_WORKTREE` | prompt string | Git: skip-worktree files
`GIT_PROMPT_KIT_STASHES` | prompt string | Git: stash
`GIT_PROMPT_KIT_TAG` | prompt string | Git: tag at HEAD
`GIT_PROMPT_KIT_UNTRACKED` | prompt string | Git: untracked (not staged) files
`GIT_PROMPT_KIT_UPSTREAM` | prompt string | Git: "local" if no upstream; upstream branch if the name differs from the local branch; upstream remote and branch if the remote is not the default
`GIT_PROMPT_KIT_USERHOST` | prompt string | User and host

### Molecule components

Name | Type | Description
---|---|---
`GIT_PROMPT_KIT_REF` | prompt string | `GIT_PROMPT_KIT_HEAD`, `GIT_PROMPT_KIT_AHEAD`, `GIT_PROMPT_KIT_BEHIND`, `GIT_PROMPT_KIT_UPSTREAM`, `GIT_PROMPT_KIT_TAG`
`GIT_PROMPT_KIT_STATUS_EXTENDED` | prompt string | `GIT_PROMPT_KIT_STASHES`, `GIT_PROMPT_KIT_ASSUMED_UNCHANGED`, `GIT_PROMPT_KIT_SKIP_WORKTREE`
`GIT_PROMPT_KIT_STATUS` | prompt string | `GIT_PROMPT_KIT_UNTRACKED`, `GIT_PROMPT_KIT_CONFLICTED`, `GIT_PROMPT_KIT_DELETED`, `GIT_PROMPT_KIT_MODIFIED`, `GIT_PROMPT_KIT_NEW`, `GIT_PROMPT_KIT_DELETED_STAGED`, `GIT_PROMPT_KIT_MODIFIED_STAGED`

### Other

Name | Description
---|---
`GIT_PROMPT_KIT_DIRTY` | Equal to `1` if the Git worktree is dirty

## Performance

Git Prompt Kit is built on gitstatus. See [gitstatus's documentation](https://github.com/romkatv/gitstatus) for details on its performance and how it works.

Snapshot with macOS 10.14 on early-2015 MacBook Pro (2.9 GHz Intel Core i5, 16 GB 1867 MHz DDR3), zsh 5.3, zinit 3.1, iTerm2 3.3.9.

Adds about 50ms to the initial interactive session load time (time to first prompt after opening a new iTerm2 window), as measured by `zinit times` given

```shell
# zshrc
autoload -U add-zsh-hook
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light olets/git-prompt-kit
```

Git Prompt Kit has a roughly sub-10ms impact on time per prompt (time to draw new prompt after finishing previous command) in a non-Git directory _or_ a Git directory, regardless of `GIT_PROMPT_KIT_SET_PROMPT` value, as measured by comparing `zsh-prompt-benchmark` given

```shell
# zshrc
autoload -U add-zsh-hook
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light romkatv/zsh-prompt-benchmark
```

to `zsh-prompt-benchmark` given

```shell
# zshrc
autoload -U add-zsh-hook
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit light romkatv/zsh-prompt-benchmark
zinit light olets/git-prompt-kit
```

## Acknowledgments

Git Prompt Kit is built on Roman Perepelitsa's [gitstatus](https://github.com/romkatv/gitstatus).

Showing "dimmed" components was inspired by Arialdo Martini's [oh-my-git](https://github.com/arialdomartini/oh-my-git), which leaves space for inactive symbols.

Using Git status's short format was inspired by Michael Allen's [git-radar](https://github.com/michaeldfallen/git-radar).

## Changelog

See the [CHANGELOG](CHANGELOG.md) file.

## Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/git-prompt-kit/issues) to see if your topic has been discussed before or if it is being worked on. You may also want to check the roadmap (see above). Discussing in an Issue before opening a Pull Request means future contributors only have to search in one place.

This project includes a Git [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules). Passing `--recurse-submodules` when `git clone`ing is recommended.

This project loosely follows the [Angular commit message conventions](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit). This helps with searchability and with the changelog, which is generated automatically and touched up by hand only if necessary. Use the commit message format `<type>(<scope>): <subject>`, where `<type>` is **feat** for new or changed behavior, **fix** for fixes, **docs** for documentation, **style** for under the hood changes related to for example zshisms, **refactor** for other refactors, **test** for tests, or **chore** chore for general maintenance (this will be used primarily by maintainers not contributors, for example for version bumps). `<scope>` is more loosely defined. Look at the [commit history](https://github.com/olets/git-prompt-kit/commits/main) for ideas.

## License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT).
For the full text of the license, see the [LICENSE](LICENSE) file.

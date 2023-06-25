<img src="./img/hometown.png" alt="">

# Hometown Prompt ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/hometown-prompt) ![GitHub commits since latest release (by SemVer)](https://img.shields.io/github/commits-since/olets/hometown-prompt/latest)

**Hometown is a feature rich, high performance Git-aware zsh theme** with segments for the user, host, time, the current working directory and its parent, and —within a Git repo— detailed Git status. It is carefully designed to show a lot of information clearly.

Get a feel for how the components respond to context and how the options work by playing with the online simulator: <a href="https://hometown-prompt.olets.dev/">https://hometown-prompt.olets.dev/</a>.

&nbsp;

> 🎉 The next major version of Hometown Prompt is in the works, complete with a brand new documentation site. Take a look in the [`next` branch](https://github.com/olets/hometown-prompt/tree/next)

&nbsp;

<!-- TOC -->
- [Requirements](#requirements)
- [Installation](#installation)
    - [With a shell plugin manager](#with-a-shell-plugin-manager)
    - [Manual](#manual)
- [Usage](#usage)
    - [Examples](#examples)
    - [Options](#options)
- [Contributing](#contributing)
- [License](#License)

## Requirements

- Zsh

## Installation

Shell plugin manager is the recommended installation method.

### With a shell plugin manager

1. Install hometown-prompt with a zsh plugin manager. Each has their own way of doing things. See your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a).

    After adding the plugin to the manager, restart zsh:

    ```shell
    exec zsh
    ```

### Manual

Either clone this repo and add `source path/to/hometown-prompt.zsh` to your `.zshrc`, or

1. Download [the latest `hometown-prompt` binary](https://github.com/olets/hometown-prompt/releases/latest)
1. Put the file `hometown-prompt` in a directory in your `PATH`

Then restart zsh:

```shell
exec zsh
```

## Usage

Hometown shows, in this order

Always:

- The current user, if not one you've configured as hidden
- The current host, if not one you've configured as hidden
- The time the prompt was drawn
- User-configured content
- The current working directory
  - The number of path segments before the CWD is configurable.

If in a Git repo:

- If the current working directory is a subdirectory in a Git repo, the Git root is shown (prefixed by the configured number of path segments) followed by the current working directory (prefixed by a separately-configured number of path segments between the Git root and the CWD). The Git repo's root is underlined. For example, "git-parent/g͟i͟t͟-͟r͟o͟o͟t/git-child", "git-parent/g͟i͟t͟-͟r͟o͟o͟t/.../git-grandchild/git-great-grandchild-cwd".
- If HEAD is detached, the checked out commit, colored if the index is dirty
- If a branch is checked out:
  - Its name, colored if the index is dirty
  - If it  does not have a remote tracking branch, the word "local"
  - If it has an upstream (that is, [`@{upstream}`](https://www.git-scm.com/docs/gitrevisions#Documentation/gitrevisions.txt-emltbranchnamegtupstreamemegemmasterupstreamememuem)),
    - The number of commits ahead of the upstream the local branch is, if any
    - The number of commits behind the upstream the local branch is, if any
    - The upstream's remote, if different from the user-configured default
    - The upstream's name, if different from the local branch's
    - Color is dependent on context and status:
      - If no distinct push remote, colored if the local is either ahead or behind
      - If there a distinct push remote, colored if the local is behind
  - If it has a push remote (that is, [`@{push}`](https://www.git-scm.com/docs/gitrevisions#Documentation/gitrevisions.txt-emltbranchnamegtpushemegemmasterpushemempushem)) different from the upstream,
    - The number commits ahead of the push remote the local branch is, if any
    - The number commits behind the push remote the local branch is, if any
    - The push remote's remote, if different from the user-configured default
    - (The push branch's name is not shown. Want it to be? Weigh in at at [romkatv/gitstatus/#291](https://github.com/romkatv/gitstatus/issues/291))
- The first tag pointing to the current commit, if there is one
- The number of stashes
- The number of files with the assume-unchanged bit set
- The number of files with the skip-worktree bit set
- The number of untracked ("new") files
- The number of conflicted files
- The number of unstaged deleted files
- The number of unstaged modified files
- The number of staged new files
- The number of staged deleted files
- The number of staged modified files
- The name of the ongoing action (for example "rebase") if any

### Examples

Try out Hometown at https://hometown-prompt.olets.dev/.

In the below screenshot, the user configuration specifies that dimmed symbols should not be shown for Git status counts equal to zero (see [Options](#options)). The prompt shows that `main` is checked out and dirty; it is one commit ahead of the remote tracking branch; there are three stashes, no untracked files, no conflicted files, no unstaged deleted files, one unstaged modified file, no staged new files, no staged deleted files, and one staged modified file; the previous command succeeded; the user is not root; and, implicitly, that neither the user or host is unexpected, the upstream branch is `origin/main`, the local branch is not behind it, there is no distinct push remote, there is no tag at `HEAD`, there are no files with the assume-unchanged bit set, there are no files with the skip-worktree bit set, and there is no action (e.g. merge, rebase, cherry-pick) underway.

<figure>
<img src="./img/hometown-default.jpg">
<figcaption>
As text:
<pre>
19:29:25 olets/gi̲t̲-̲pr̲o̲m̲pt̲-̲k̲i̲t̲ main +1
3⇲ ?? UU _D 1_M A_ D_ 1M_
% # time, directory, branch, one commit ahead of remote
  # three stashes, one unstaged modified file, one staged modified file
</pre>
</figcaption>
</figure>

### Options

Hometown is highly customizable. Change the colors and symbols, add or remove line breaks, specify the number of path segments to show before the current working directory, hide or show inactive elements (for example, show the Git status symbols, dimmed, when the local branch is up to date with its upstream, as seen in the above screenshot), and much more.

🌟 Most configuration is done through Git Prompt Kit. See [Git Prompt Kit's Options](https://github.com/olets/git-prompt-kit#options).

In addition there are Hometown Prompt-specific options:

Name | Type | Description | Default
---|---|---|---
`HOMETOWN_PROMPT_CUSTOM` | prompt string* | Shown between the time and the working directory | 
`HOMETOWN_PROMPT_SHOW_EXTENDED_STATUS` | number | If non-zero show the stash count, assume-unchanged file count, and skip-worktree file count | `1`

\* Output with `print -P`; see ["Prompt Expansion"](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html) in the zsh documentation for more information.

## Performance

Hometown adds less than 10ms to the time between prompts, as measured by [`zsh-prompt-benchmark`](https://github.com/romkatv/zsh-prompt-benchmark).

Hometown uses Git Prompt Kit. See [Git Prompt Kit](https://github.com/olets/git-prompt-kit) for performance details.

## Acknowledgments

Splash card font is [Nickainley](https://www.fontfabric.com/fonts/nickainley/) by Seniors Studio.

See [Git Prompt Kit's acknowledgments](https://github.com/olets/git-prompt-kit#acknowledgments) for more.

## Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/hometown-prompt/issues) to see if your topic has been discussed before or if it is being worked on.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#" class="license-text"><a rel="cc:attributionURL" property="dct:title" href="https://www.github.com/olets/hometown-prompt">hometown-prompt</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://www.github.com/olets">Henry Bley-Vroman</a> is licensed under <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> plus <a href="https://firstdonoharm.dev/version/2/1/license.html">Hippocratic License 3</a>. Persons interested in using or adapting this work for commercial purposes should contact the author.</p>

<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" title="Creative Commons-licensed" /> <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" title="Creative Commons: Attribution" /> <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" title="Creative Commons: NonCommercial"/> <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" title="Creative Commons: ShareAlike" />

For the full text of the license, see the [LICENSE](LICENSE) file.

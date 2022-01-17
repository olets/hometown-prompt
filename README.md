<img src="./img/hometown.png" alt="">

# Hometown Prompt ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/hometown-prompt)

**Hometown is a feature rich, high performance Git-aware zsh theme** with segments for the user, host, time, the current working directory and its parent, and detailed full Git status with in a Git repo.

Get a feel for how the components respond to context and how the options work by playing with the online simulator: <a href="https://hometown-prompt.netlify.app/">https://hometown-prompt.netlify.app/</a>.

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

Hometown shows

- The current user, if not one you've configured as hidden
- The current host, if not one you've configured as hidden
- The time the prompt was drawn
- Any custom prompt content
- The current working directory, or other custom content
- The checked out branch or, if HEAD is detached, the checked out commit
  - color is determined by whether or not the index is dirty
- If a branch is checked out:
  - Its name, colored by whether or not the index is dirty
  - If it has an upstream (that is, [`@{upstream}`](https://www.git-scm.com/docs/gitrevisions#Documentation/gitrevisions.txt-emltbranchnamegtupstreamemegemmasterupstreamememuem)),
    - How many commits ahead of the upstream it is
    - How many commits behind the upstream it is
    - The upstream's name if different from the local's
    - The upstream's remote if different from your default
  - If it has a push remote (that is, [`@{push}`](https://www.git-scm.com/docs/gitrevisions#Documentation/gitrevisions.txt-emltbranchnamegtpushemegemmasterpushemempushem)) different from the upstream,
    - How many commits ahead of the push remote it is
    - How many commits behind the push remote it is
    - The push remote's remote if different from your default
    - Want to show the upstream branch's name? Weigh in at at [romkatv/gitstatus/#291](https://github.com/romkatv/gitstatus/issues/291)
- Up to one tag which points to the current commit
- The stash count
- The assume-unchanged files count
- The skip-worktree files count
- The untracked ("new") files count
- The conflicted files count
- The unstaged deleted files count
- The unstaged modified files count
- The staged new files count
- The staged deleted files count
- The staged modified files count
- The name of the ongoing action, if any

### Examples

Try out Hometown at https://hometown-prompt.netlify.app/.

In the below screenshot, the user configuration specifies that dimmed symbols should be shown for Git status counts equal to zero (see [Options](#options)). The prompt shows that `main` is checked out and dirty; it is one commit ahead of the remote tracking branch; there are three stashes, no untracked files, no conflicted files, no unstaged deleted files, one unstaged modified file, no staged new files, no staged deleted files, and one staged modified file; the previous command succeeded, and that the user is not root; and, implicitly, that neither the user or host is unexpected, the upstream branch is `origin/main`, the local branch is not behind it, there is no distinct push remote, there is no tag at `HEAD`, there are no files with the assume-unchanged bit set, there are no files with the skip-worktree bit set, and there is no action (e.g. merge, rebase, cherry-pick) underway.

<figure>
<img src="./img/hometown-default.jpg">
<figcaption>
As text:
<pre>
19:29:25 olets/git-prompt-kit main +1
3⇲ ?? UU _D 1_M A_ D_ 1M_
% # time, directory, branch, one commit ahead of remote
  # three stashes, one unstaged modified file, one staged modified file
</pre>
</figcaption>
</figure>

### Options

Hometown is highly customizable. Change the colors and symbols, add and remove line breaks, modify the current working directory segment, show inactive elements (for example, show the Git status symbols, dimmed, when the local branch is up to date with its upstream, as seen in the above screenshot), and more.

Most configuration is done through Git Prompt Kit. See [Git Prompt Kit's Options](https://github.com/olets/git-prompt-kit#options).

You can also configure `HOMETOWN_PROMPT_CUSTOM`. This is shown between the time and the working directory. It is a prompt string (output with `print -P`); see ["Prompt Expansion"](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html) in the zsh documentation for more information.

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

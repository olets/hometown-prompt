<img src="./img/hometown.png" alt="">

# Hometown Prompt ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/hometown-prompt) ![GitHub commits since latest release (by SemVer)](https://img.shields.io/github/commits-since/olets/hometown-prompt/latest)

**Hometown is a feature rich, high performance Git-centric zsh theme** with segments for the user, host, time, the current working directory and its parent, and —within a Git repo— detailed Git status. It is carefully designed to show dense information clearly.

&nbsp;

> This is the WIP branch for the next major version. **It may be force pushed.**

&nbsp;

## Documentation

<!-- TODO drop `next.` -->

📖 See the guide, including a web simulation demonstrating how the prompt responds to context and configuration, at https://next.hometown-prompt.olets.dev/

&nbsp;

Depending on how you configure it, Hometown looks something like this:

![Hometown Prompt example screenshot](https://next.hometown-prompt.olets.dev/images/hometown-prompt-example.jpg)

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

## Changelog

See the [CHANGELOG](CHANGELOG.md) file.

## Acknowledgments

Splash card font is [Nickainley](https://www.fontfabric.com/fonts/nickainley/) by Seniors Studio.

See [Git Prompt Kit's acknowledgments](https://github.com/olets/git-prompt-kit#acknowledgments) for more.

## Contributing

_Looking for the documentation site's source? See <https://github.com/olets/hometown-prompt-docs>_

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/hometown-prompt/issues) to see if your topic has been discussed before or if it is being worked on. You may also want to check the roadmap (see above).

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

### Sponsoring

Love Hometown Prompt? I'm happy to be able to provide it for free. If you are moved to turn appreciation into action, I invite you to make a donation to one of the organizations listed below (to be listed as a financial contributor, send me a receipt via email or [Reddit DM](https://www.reddit.com/user/olets)). Thank you!

- [O‘ahu Water Protectors](https://oahuwaterprotectors.org/) a coalition of organizers and concerned community members fighting for safe, clean water on Oʻahu. Currently focused on the Red Hill Bulk Fuel Storage Facility crisis (see Sierra Club of Hawaii's [explainer](https://sierraclubhawaii.org/redhill)).
- [Hoʻoulu ʻĀina](https://hoouluaina.org/) is a 100-acre nature preserve nestled in the back of Kali hi valley on the island of Oʻahu which seeks to provide people of our ahupuaʻa and beyond the freedom to make connections and build meaningful relationships with the ʻāina, each other and ourselves.
- [Ol Pejeta Conservancy](https://www.olpejetaconservancy.org/) are caretakers of the land, safeguarding endangered species and ensuring the openness and accessibility of conservation for all. They empower their people to think the same way and embrace new approaches to conservation, and provide natural wilderness experiences, backed up by scientifically credible conservation and genuine interactions with wildlife.
- [Southern Utah Wilderness Alliance (SUWA)](https://suwa.org/) the only non-partisan, non-profit organization working full time to defend Utah’s redrock wilderness from oil and gas development, unnecessary road construction, rampant off-road vehicle use, and other threats to Utah’s wilderness-quality lands.

## License

<a href="https://www.github.com/olets/hometown-prompt">Hometown Prompt</a> by <a href="https://www.github.com/olets">Henry Bley-Vroman</a> is licensed under a license which is the unmodified text of <a href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> and the unmodified text of a <a href="https://firstdonoharm.dev/build?modules=eco,extr,media,mil,sv,usta">Hippocratic License 3</a>. It is not affiliated with Creative Commons or the Organization for Ethical Source.

Human-readable summary of (and not a substitute for) the [LICENSE](LICENSE) file:

You are free to

- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material

Under the following terms

- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- Non-commercial — You may not use the material for commercial purposes.
- Ethics - You must abide by the ethical standards specified in the Hippocratic License 3 with Ecocide, Extractive Industries, US Tariff Act, Mass Surveillance, Military Activities, and Media modules.
- Preserve terms — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
- No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

## Acknowledgments

- The human-readable license summary is based on https://creativecommons.org/licenses/by-nc-sa/4.0. The ethics point was added.
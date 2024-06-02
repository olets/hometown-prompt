# [v3.1.4](/compare/v3.1.3...v3.1.4) (2024-06-02)


### Bug Fixes

* enable prompt substitution [7d8cc29](https://github.com/olets/hometown-prompt/commit/7d8cc29)


### Features

* **ci:** do not bump homebrew for github prereleases [596cba2](https://github.com/olets/hometown-prompt/commit/596cba2)
* **git-prompt-kit:** upgrade from 4.1.2 (10c164e) to 4.1.3 (4a168ef) [1551944](https://github.com/olets/hometown-prompt/commit/1551944)



# [v3.1.3](/compare/v3.1.2...v3.1.3) (2024-03-26)

* **deps:** bump git-prompt-kit from `742f995` to `f5979bb` v4.1.2 [fe09de1](https://github.com/olets/hometown-prompt/commit/fe09de14715e5dc853481227462013d01b61bf91)


# [v3.1.2](/compare/v3.1.1...v3.1.2) (2023-12-11)


### Features

* **deps:** bump git-prompt-kit from `21c5028` to `742f995` v4.1.1 [d451e22](https://github.com/olets/hometown-prompt/commit/d451e222d69b2b67d6a2a46ea493f04e13ece856)
* **releases:** action to bump formula with each release [8283f94](https://github.com/olets/hometown-prompt/commit/8283f94)



# [v3.1.1](/compare/v3.1.0...v3.1.1) (2023-12-06)

* **version variable:** follow naming convention [5cec140](https://github.com/olets/hometown-prompt/commit/5cec140f39c5485d87318ead64522c91df11d6cc)



# [v3.1.0](/compare/v3.0.0...v3.1.0) (2023-12-05)

### Features

* **git-prompt-kit:** upgrade to v4.1.0 [d1aa126](https://github.com/olets/hometown-prompt/commit/d1aa126)
* **submodules:** init if necessary [862f29a](https://github.com/olets/hometown-prompt/commit/862f29a3c243fd5e5ac4b7982f93cf5948649aa3)



# [v3.0.0](/compare/v2.0.1...v3.0.0) (2023-12-05)


### Features

* **deps:** update git-prompt-kit to v4.0.0
* **working directory:** use GIT_PROMPT_KIT_CWD [ca46db2](https://github.com/olets/hometown-prompt/commit/ca46db2)
* **HOMETOWN_PROMPT_VERSION:** add [bac5c8f](https://github.com/olets/hometown-prompt/commit/bac5c8f)
* **layout options:** two new config options (prev in git-prompt-kit) [fd80d33](https://github.com/olets/hometown-prompt/commit/fd80d33)
  - `HOMETOWN_PROMPT_LINEBREAK_AFTER_GIT_REF` and `HOMETOWN_PROMPT_NO_LINEBREAK_BEFORE_GIT_REF`
* **HOMETOWN_PROMPT_VERSION:** add [bac5c8f](https://github.com/olets/hometown-prompt/bac5c8f817ac1658c282785e8d55990aae618075)
* **time:** move into HOMETOWN_PROMPT_CUSTOM [b031664](https://github.com/olets/hometown-prompt/commit/b031664c49ff38909c93eda2cd96954a22baa7f5)
* **names:** drop '_prompt' from file, function, and var names [a164132](https://github.com/olets/hometown-prompt/a1641326d73b6f3012061182fe9cb002bb5e69cf)
* **theme file:** extension is zsh-theme [e9f8b6a](olets/hometown-prompt/e9f8b6afcd2b06c6016b4438cc42d2b375d8ea16)


# [v2.0.1](/compare/v2.0.0...v2.0.1) (2022-11-27)


### Bug Fixes

* **binaries:** delete and ignore [cc08f8b](https://github.com/olets/hometown-prompt/commit/cc08f8b)


### Features

* **extended status:** new HOMETOWN_PROMPT_SHOW_EXTENDED_STATUS option [f5de6f7](https://github.com/olets/hometown-prompt/commit/f5de6f7)
* **git-prompt-kit:** update submodule v3.0.1
* **git:** no space before status if no extended status [db3b9c3](https://github.com/olets/hometown-prompt/commit/db3b9c3)



# [v2.0.0](/compare/v1.1.0...v2.0.0) (2022-01-17)

Working directory enhancements. See https://github.com/olets/git-prompt-kit/releases/tag/v3.0.0

Breaking change: Git Prompt Kit has dropped the "custom" component. Use Hometown's custom component instead.

### Features

* **git-prompt-kit:** upgrade to v3.0.0 [379b371](https://github.com/olets/hometown-prompt/commit/379b37194e1b1342f00cc01fc0943a22b657a000)
* **plugin:** new HOMETOWN_PROMPT_CUSTOM [5efefb2](https://github.com/olets/hometown-prompt/commit/5efefb2)



# [v1.1.0](https://github.com/olets/hometown-prompt/compare/v1.0.0...v1.1.0) (2022-01-17)

Adds push remote support. See https://github.com/olets/git-prompt-kit/releases/tag/v2.1.0

### Features

* **git-prompt-kit:** bump to v2.1.0 [60f9205](https://github.com/olets/hometown-prompt/commit/60f9205)



# [v1.0.0](https://github.com/olets/hometown-prompt/compare/initial...v1.0.0) (2021-12-28)

Initial release. This project was broken out as a standalone from [Git Prompt Kit](https://github.com/olets/git-prompt-kit).




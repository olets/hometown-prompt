# [2.1.0](https://github.com/olets/git-prompt-kit/compare/v2.0.0...v2.1.0) (2022-01-15)

Now with push remote support!
### Features

* **copyright:** through present ([2279dc5](https://github.com/olets/git-prompt-kit/commit/2279dc51ecef79eb3202c359743b59119853e8ca))
* **GIT_PROMPT_KIT_DEFAULT_REMOTE:** rename GIT_PROMPT_KIT_DEFAULT_REMOTE_NAME ([4016b9b](https://github.com/olets/git-prompt-kit/commit/4016b9b5f1d77680747d77d6b445b8856f6a3060))
* **ref:** always show remote symbols ([9e04a91](https://github.com/olets/git-prompt-kit/commit/9e04a91ce32d628179c02e94ba412ce567461fc9))
* **ref:** show 'local' only if no u and no push ([8d74a18](https://github.com/olets/git-prompt-kit/commit/8d74a183fa950c6249d3af9885452153fd010cc1))
* **ref:** support push remote ([2d114d3](https://github.com/olets/git-prompt-kit/commit/2d114d368a18c8714aa45f7dee711c76ad28703d))



# [2.0.0](https://github.com/olets/porcelain-prompt/compare/v1.x...v2.0.0) (2021-12-28)

The big change: Git Prompt Kit does not come with a theme. See [Hometown prompt](https://github.com/olets/hometown-prompt) for my theme.

### Bug Fixes

* **ahead/behind:** colors were swapped ([020c609](https://github.com/olets/git-prompt-kit/commit/020c609fc6695e3c7c84342816661254c815889a))
* **char:** only show root char if root ([22e7b08](https://github.com/olets/git-prompt-kit/commit/22e7b0856b037f4d4b0668d15b93964786fbd0ba))
* **custom prompt:** do not show git info when moving to non-git dir ([664fad4](https://github.com/olets/git-prompt-kit/commit/664fad468c2a8c70b8cc57d2a09eece3244623f2))
* **expansion:** add missing '$'s ([664e1a0](https://github.com/olets/git-prompt-kit/commit/664e1a08628743ecf843dcda2afa2f5bbcb537e6))
* **git:** correct support for line break configuration ([a1ae741](https://github.com/olets/git-prompt-kit/commit/a1ae74191b67b15f55061fb72752621b435b9d2d))
* **git head:** color works ([8ed8cc7](https://github.com/olets/git-prompt-kit/commit/8ed8cc7ad9bddfb83e847c64bef7445187cdc1cd))
* **git status:** clear when leaving repo ([e9af5d5](https://github.com/olets/git-prompt-kit/commit/e9af5d555b5af3c6bf6701b029e03299de195237))
* **git where:** clear when moving out of a git repo ([b5c0f6d](https://github.com/olets/git-prompt-kit/commit/b5c0f6d98c9a09a3a702b26b05cc5dd890c0ad9b))
* **modified staged:** correct spacing ([9edf465](https://github.com/olets/git-prompt-kit/commit/9edf4659b55876da402e5c649f39f308252bd819))
* **plugin:** revert breaking typo ([0dc3eba](https://github.com/olets/git-prompt-kit/commit/0dc3eba872791fa4ad15b9e4dd900d2e2fcdff92))
* **recipes:** starship example respects line break config ([483535c](https://github.com/olets/git-prompt-kit/commit/483535c9ffd2a5de79f345ed3af7220f3788a52b))
* **remote:** color works ([72a982e](https://github.com/olets/git-prompt-kit/commit/72a982e9697a5f04073cecb22dcf1861aafb7c97))
* **tool names:** tool names can be shown ([87d8ba5](https://github.com/olets/git-prompt-kit/commit/87d8ba5ba970d436a73ed196669116c3265fdafa))
* **where:** space prefix if on same line as directory info ([e6fbeb1](https://github.com/olets/git-prompt-kit/commit/e6fbeb144303c2246bab9f54fab148f5c59cecd4))


### Features

* **accessibility:** better color contrast ([780c534](https://github.com/olets/git-prompt-kit/commit/780c534adbf3dc7edd72da44e8616ab2d55c478e))
* **ahead:** use remote color ([9961628](https://github.com/olets/git-prompt-kit/commit/9961628d768ec8a618d84f123fd6e9992ad906d4))
* **ahead, behind:** simplify symbols ([0444624](https://github.com/olets/git-prompt-kit/commit/0444624214e8f560fc8bd4e04f52fb8efce30ab9))
* **ahead, behind:** solid-shaft arrow, aren't taller than numbers ([ed46c07](https://github.com/olets/git-prompt-kit/commit/ed46c07cd9a57c05767e7a537739668ca0b7272a))
* **ahead, behind:** symbol comes before count ([46d6902](https://github.com/olets/git-prompt-kit/commit/46d69029e96f7c031d049ac5ce204b01c2f9b7ce))
* **ahead, behind, remote:** remote comes before ahead/behind ([369581d](https://github.com/olets/git-prompt-kit/commit/369581d880abbf0a868282ec072b5030e0046228))
* **ahead/behind:** support independent hiding when inactive ([7bd397b](https://github.com/olets/git-prompt-kit/commit/7bd397bff2d1d82f265eb65b4e353c1499135955))
* **ahead/behind, extended status:** hide inactives by default ([7f02618](https://github.com/olets/git-prompt-kit/commit/7f02618b03d01b5d777ece7eacbbff970cb3b8b9))
* **assume, skip:** support custom colors ([e835368](https://github.com/olets/git-prompt-kit/commit/e835368e33e22a90dacc96984529a25f37a5d7bb))
* **branch:** do not say 'local' if HEAD is detached ([cbdf99b](https://github.com/olets/git-prompt-kit/commit/cbdf99b51b554de1169bbc3b55c33d293f59f425))
* **branch:** show symbol in mismatched upstream ([87124fe](https://github.com/olets/git-prompt-kit/commit/87124fe1e79d3c32f85414bdde3a105162a08cef))
* **branch, commit:** support not showing any symbol ([7f672fd](https://github.com/olets/git-prompt-kit/commit/7f672fdbfb8818afb2777b93f9b7c9b6c0493a2d))
* **branch, tag:** swap default symbols + tag can have no symbol ([7d1bbe8](https://github.com/olets/git-prompt-kit/commit/7d1bbe8dee0f73b079974a0cc0b4a9de610c704d))
* **colors:** all are configurable ([2d2ad69](https://github.com/olets/git-prompt-kit/commit/2d2ad6933a5e81698f5ca5e6ad40373624727eef))
* **colors:** config-printing function + clarify docs ([fe2c836](https://github.com/olets/git-prompt-kit/commit/fe2c8363723b0f7f31a829ad01db9bfa63063c64))
* **colors:** support names, 8-bit, and 24-bit ([f49117b](https://github.com/olets/git-prompt-kit/commit/f49117bcb4674a66b23904ef19506b4f86b16e62))
* **colors:** use olets's (24-bit) theme + built in zsh/nearcolor load ([998d7a8](https://github.com/olets/git-prompt-kit/commit/998d7a87ebf64059fc95b22e24874b300bb05497))
* **config:** allow null for all but non-boolean options ([a88b282](https://github.com/olets/git-prompt-kit/commit/a88b282df956aae5e5af5eae2d3dd75b7d326d80))
* **context:** separate 'show inactive' configuration ([4e37c43](https://github.com/olets/git-prompt-kit/commit/4e37c431ff4f4361f71d3906f4efe4932a4962ef))
* **custom:** rename from cwd to reflect flexibility ([de94b95](https://github.com/olets/git-prompt-kit/commit/de94b957ef0ad50aa47c09bb6737ff450bdfd93d))
* **cwd:** customizable ([a2eeadf](https://github.com/olets/git-prompt-kit/commit/a2eeadfdeeb3fbdcefd20d1535da61ec60d7d505))
* **default prompt:** move to own project ([5e6a7aa](https://github.com/olets/git-prompt-kit/commit/5e6a7aa6a358102f00b3517fbd87e97e7e15eae0))
* **git:** export DIRTY variable for use in custom + close coloration ([ef84e10](https://github.com/olets/git-prompt-kit/commit/ef84e10c3a695297ca2b0574159a79813ca9b312))
* **git head:** local flag is configurable ([a05fe1e](https://github.com/olets/git-prompt-kit/commit/a05fe1ebb9045a601ad985abdcc50cd9b9c63e81))
* **git prompt:** make all pieces available even if not setting prompt ([5eb161a](https://github.com/olets/git-prompt-kit/commit/5eb161a87a3955e42b06fdc86eacea338b403083))
* **git prompt:** new ref, status, and extended status components ([6ca1692](https://github.com/olets/git-prompt-kit/commit/6ca1692e26925a0e924666e7b925e2f45d0c5da9))
* **gitstatus:** add submodule and source local copy ([caf08c1](https://github.com/olets/git-prompt-kit/commit/caf08c100906fc19cb8755871525f37d36886da9))
* **gpk:** add shebang ([855a7a4](https://github.com/olets/git-prompt-kit/commit/855a7a40687e57b725c15ad9e69d0c94e68c50c3))
* **HEAD:** default to no symbols ([8044e59](https://github.com/olets/git-prompt-kit/commit/8044e591d14f18f23435459fc429b65ee9c02157))
* **host:** configurable symbol ([0c2fd80](https://github.com/olets/git-prompt-kit/commit/0c2fd809a4dd860759fe885d834d4178f2736ab3))
* **host:** default symbol is '@' ([84878a8](https://github.com/olets/git-prompt-kit/commit/84878a8dbc639407cf7dd5676511a13bfb757e3d))
* **inactives:** can be configured to hide ([416633d](https://github.com/olets/git-prompt-kit/commit/416633d59e75958efb102837ba1e535edd6e3e30))
* **index flags:** show assume-unchanged and skip-worktree counts ([d7f8ef5](https://github.com/olets/git-prompt-kit/commit/d7f8ef579406239e99d4b82150de6227fb204792))
* **license:** apply full Hippocratic License v3 in place of v2.1 clause ([1a2c0b8](https://github.com/olets/git-prompt-kit/commit/1a2c0b8b601ce5d0de2bce529abd78394dc0bc9b))
* **lines:** support putting everything on one line ([b456035](https://github.com/olets/git-prompt-kit/commit/b456035860f529e1ed7e44df8bc611de7dab50ec))
* **options:** new command 'git-prompt-kit-config' to output config ([fc92a57](https://github.com/olets/git-prompt-kit/commit/fc92a575b4e2b479274e04c5f1ae0e04c29a408c))
* **plugin:** support loading via plugin file ([98faba3](https://github.com/olets/git-prompt-kit/commit/98faba3c90f96e956b672c38562b5a8c62aaf332))
* **prompt:** add gitstatus as starting point ([084dae1](https://github.com/olets/git-prompt-kit/commit/084dae191acddcca1ce7d212219551b8b892249e))
* **prompt:** can opt out of building prompt ([e4d1c57](https://github.com/olets/git-prompt-kit/commit/e4d1c5795c2eb03b0ec1a38dc6903f5d5417670a))
* **prompt:** no building happens unless prompt is being used ([e86b359](https://github.com/olets/git-prompt-kit/commit/e86b3597877e05a7c7630c014c8b467dcc6b5933))
* **prompt:** non-git components are available for custom use ([616de79](https://github.com/olets/git-prompt-kit/commit/616de79abe8eeafd9c4c6fca59a7548cde5cbf98))
* **prompt:** porcelain status, no truncate (squash) ([7aa19df](https://github.com/olets/git-prompt-kit/commit/7aa19df72e5dad6cf6b7f192f017aa89cb567ba6))
* **prompt, kit:** no trailing spaces in prompt or molecules ([0528975](https://github.com/olets/git-prompt-kit/commit/0528975b62b6bfe9f4f41be0cefed59623513992))
* **recipes:** screenshots ([7eaa1d2](https://github.com/olets/git-prompt-kit/commit/7eaa1d2323e4e8de801c6b9904b744bb3d6eb2bb))
* **ref:** add branch and commit symbols ([345e9a1](https://github.com/olets/git-prompt-kit/commit/345e9a1f517306181850974651dc2aecc00d5f98))
* **remote:** default is configurable ([01da001](https://github.com/olets/git-prompt-kit/commit/01da001c3e99cfbb9a75e660843267c0255f1e98))
* **remote:** do not show default remote in mismatched upstream branch ([6fb9448](https://github.com/olets/git-prompt-kit/commit/6fb9448bdec821caf15571d9ba245ebcf15142ad))
* **stash, assume, skip:** space after symbol ([06fff16](https://github.com/olets/git-prompt-kit/commit/06fff16fa692170b32dd02735a275938bcdea67e))
* **stash, assume, skip:** use symbols supported by most fonts ([44a07dd](https://github.com/olets/git-prompt-kit/commit/44a07dd4a4d85781c15ad0b7db6993198013bc30))
* **symbols:** all are configurable ([5124415](https://github.com/olets/git-prompt-kit/commit/5124415d286f702e67ec0019c5f0b12100d04b26))
* **symbols:** any symbol can be null ([fe4338c](https://github.com/olets/git-prompt-kit/commit/fe4338c57482c2c8bd2a3659fffada1f1bcae3e9))
* **tag:** list after upstream ([2d765c1](https://github.com/olets/git-prompt-kit/commit/2d765c122e2e6b9b689a83d303485703d31e4123))
* **tag:** supports symbol, color is configurable, follows upstream ([5449251](https://github.com/olets/git-prompt-kit/commit/54492514af9b8a62f1d6a6cbd3829838289bcbf0))
* **user info:** clean up variables ([506e54b](https://github.com/olets/git-prompt-kit/commit/506e54b5cb8811c0193bb6f9d71b45efb5d9458f))
* **user, host:** support default values, only show if not default ([627f62a](https://github.com/olets/git-prompt-kit/commit/627f62a17e5626fb28a8dc651d420f2efb624f87))
* **vars:** continued name clarifications ([b037c91](https://github.com/olets/git-prompt-kit/commit/b037c91bc2c7aac20b9dfe659da6781d4e9e902e))
* **zsh:** set necessary options ([6fb9268](https://github.com/olets/git-prompt-kit/commit/6fb9268921ba46cc1efdeb1822730004145e987e))



# [1.0.0](https://github.com/olets/porcelain-prompt/compare/initial...v1.0.0) (2020-04-23)

Default prompt, component kit, recipes, and docs.

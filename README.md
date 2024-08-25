# Hearthstone-Randomizer

This World of Warcraft addon creates a macro that dynamically randomizes your hearthstone toys, selecting a new one each time so you're always surprised which one you use! This addon is a fork of the `random-hearthstone-toy` (see credits below). It has been updated to create a macro rather than using a hidden button, and has been updated to include newer hearthstone toys as well as the removal of Convenant specific restrictions that were outdated.

## Usage

After installing the addon and loading up World of Warcraft, a new macro will be created in your macro list called "RHT". This macro will automatically randomize a hearthstone toy. After clicking the macro, it will select a different random hearthstone toy from your inventory and update the macro to use that one instead.

If you find that a specific hearthstone toy is missing, please submit an issue via Github. I try to keep up with all the new changes but some may get missed!

## Debugging

If you are encountering issues, please submit an issue on Github. To help with debugging, please include any info from Bugsack, and download the DebugLog addon. Once WoW is open, run `/dl` and click on the HearthstoneRandomizer tab. Copy the contents of the tab and include it in your issue.

## Installation

This addon is now available on Wago.io! [Click here to install via Wago.io](https://addons.wago.io/addons/hearthstone-randomizer)

To install it manually, or via the Github link installer on the WoWUp installer, download the latest release from the [releases page](https://github.com/lyledouglass/hearthstone-randomizer/releases) and extract the contents to your `World of Warcraft\_retail_\Interface\AddOns` folder.

To install via WoWUp, click the "Install from URL" button and paste the following URL: `https://github.com/lyledouglass/hearthstone-randomizer`

## Contributing

### Pull Requests

Every change in the codebase should be done via pull requests. This
applies to everyone, including the project maintainers. This is to
ensure that every change is reviewed and discussed before it goes into
the codebase, and builds are succeeding

### Conventional Commits

In order to have a clean and readable commit history, this repository
requires the use of [ConventionalCommits](https://www.conventionalcommits.org/en/v1.0.0/).
Using conventional commits will allow for automatic versioning and
changelog generation

## Credits

This addon was forked from the `random-hearthstone-toy` addon created by Hemco under the MIT license. The original addon can be found [here](https://www.curseforge.com/wow/addons/random-hearthstone-toy```).

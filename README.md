# .dotfiles

TODO: Will update this more in the future.

This repository contains my personal development environment setup files and scripts. Please feel free to use it as you wish.

## Installing Tools:
I setup my environment primarily using the `install.sh` script. I plan to change this script in the future to make it a bit more interactive and more intuitive/readable.

Simply run the script `install.sh` to setup the environment.

## Current Features Included:
- Sets up .zshrc with history and pointing to the .zshrc_custom file for aliases.
- Installs [Miniforge3](https://github.com/conda-forge/miniforge).
- Copies .vimrc to home.

## Future Plans:
- Unattended installation
- OS specific setup including iTerm2 terminal setup
- xmodmap setup for linux (mapping LCTRL to LALT to make keyboard like macOS keyboard).
- Include settings/config file to easily change settings.

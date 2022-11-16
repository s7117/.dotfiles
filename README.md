# .dotfiles

This repository contains my personal development environment setup files and scripts. Please feel free to use it as you wish.

## Installing Tools:
I setup my environment primarily using the Makefile and passing in the corresponding platform name. As of now the following Makefile targets are supported which runs their respective setup scripts:
- linux
- docker
- mac

Simply run `make <target>` to use call the respective scripts.

## Cleanup Tools:
Not Implemented Yet! Coming soon!

You can run `make clean` to revert the changes made by running one of the setup targets.

## Current Features Included:
The following features are currently implemented. Some features are not implemented in Docker to reduce any added performance overhead.
- Sets up .zshrc with history and pointing to the ./etc/zshrc_custom file for aliases and functions.
- Sets up ZSH syntax-highlighting and autosuggestions.
- Installs [Miniforge3](https://github.com/conda-forge/miniforge).
- Copies the contents of ./etc/vimrc to home.
- Custom Oh-My-Posh prompt theme.
- Copies SSH config file to ~/.ssh

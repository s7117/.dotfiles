#!/bin/zsh

# Source the functions from oh-my-zsh
source ~/.oh-my-zsh/lib/functions.zsh

# Store the current changes.
cd ~/.oh-my-zsh
git add --all
git commit -m "temp"

# Update
upgrade_oh_my_zsh

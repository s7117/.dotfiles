#!/bin/bash
########################################
CURR_DIR=$(pwd)
CURR_OS=$(uname)
########################################
# Sanity check
if [[ "$CURR_OS" != *"Linux"* ]]; then
    echo "ERROR --> Incorrect OS detected for this target!"
    exit
fi
########################################
# Save old zshrc if one exists
if [[ -f "~/.zshrc" ]]; then
    echo "LOG --> Found existing .zshrc file! Saving backup!"
    mkdir .zsh_bups
    cp ~/.zshrc ~/.zsh_bups/.bup.zshrc
    # Overwrite the .zshrc
    echo "" > .zshrc
fi
########################################
echo "LOG --> Creating directories..."
mkdir ~/.cli_tools
mkdir ~/.ssh
########################################
# Move config files around.
cp ./etc/config ~/.ssh
cp ./etc/.vimrc ~
########################################
# Install dependencies
echo "LOG --> Installing dependencies and updating..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install zsh -y
sudo apt install build-essential -y
sudo apt install wget -y
########################################
# Configure Zsh
echo "LOG --> Configuring Zsh..."
chsh -s $(which zsh)
echo "LOG --> Configuring Zsh Settings..."
echo "export HISTFILE=~/.zsh_history" >> ~/.zshrc
echo "export HISTSIZE=1000000000" >> ~/.zshrc
echo "export SAVEHIST=1000000000" >> ~/.zshrc
echo 'export HISTTIMEFORMAT="[%F %T] "' >> ~/.zshrc
echo "setopt INC_APPEND_HISTORY" >> ~/.zshrc
echo "setopt EXTENDED_HISTORY" >> ~/.zshrc
echo "setopt HIST_IGNORE_ALL_DUPS" >> ~/.zshrc
echo "autoload -Uz compinit && compinit" >> ~/.zshrc
echo "zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'" >> ~/.zshrc
########################################
# Install and Configure Oh-My-Posh.
echo "LOG --> Installing Oh-My-Posh..."
echo "export XDG_CACHE_HOME=~/.oh-my-posh" >> ~/.zshrc
echo 'export PATH=$PATH:~/.oh-my-posh/bin' >> ~/.zshrc
mkdir ~/.oh-my-posh
mkdir ~/.oh-my-posh/bin
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O ~/.oh-my-posh/bin/oh-my-posh
chmod +x ~/.oh-my-posh/bin/oh-my-posh
echo "LOG --> Setting Oh-My-Posh Theme..."
echo 'eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/etc/s7117.omp.json)"' >> ~/.zshrc
echo 'source ~/.dotfiles/etc/.zshrc_custom' >> ~/.zshrc
########################################
# Install CLI tools.
## Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.cli_tools/zsh-autosuggestions
echo "source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
## Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.cli_tools/zsh-syntax-highlighting
echo "source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
########################################
# Install Miniforge3
if [[ ! -d "~/.miniforge3" ]]; then
    echo "LOG --> Installing Miniforge3..."
    mkdir ~/.miniforge3
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    chmod 700 "./Miniforge3-$(uname)-$(uname -m).sh"
    zsh "./Miniforge3-$(uname)-$(uname -m).sh -b -p ~/.miniforge3 -f"
    rm ./Miniforge3*
    ~/.miniforge3/bin/conda init zsh
fi
########################################
# Post Run Instructions
echo "DONE"
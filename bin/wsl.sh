#!/bin/bash
################################################################################
CURR_DIR=$(pwd)
CURR_OS=$(uname)
################################################################################
# Sanity check
if [[ "$CURR_OS" != *"Linux"* ]]; then
    echo "ERROR --> Incorrect OS detected for this target!"
    exit
fi
################################################################################
# Save old zshrc if one exists
if [[ -f "$HOME/.zshrc" ]]; then
    echo "LOG --> Found existing .zshrc file! Saving backup!"
    mkdir $HOME/.zsh_bups
    cp ~/.zshrc ~/.zsh_bups/.bup.zshrc
    # Delete old .zshrc
    rm "$HOME/.zshrc"
fi
################################################################################
echo "LOG --> Creating directories..."
mkdir ~/.cli_tools
mkdir ~/.ssh
################################################################################
# Move config files around.
cp ./etc/config ~/.ssh
cp ./etc/vimrc ~/.vimrc
################################################################################
# Enable and configure ufw
sudo ufw enable
sudo ufw default deny
sudo systemctl enable ufw
sudo systemctl start ufw
echo "Connect network now..."
read TEMPCONT
################################################################################
# Install dependencies
echo "LOG --> Installing dependencies and updating..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install zsh build-essential wget curl vim htop neofetch -y
################################################################################
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
echo 'source ~/.dotfiles/etc/zshrc_custom' >> ~/.zshrc
################################################################################
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
################################################################################
# Install CLI tools.
## Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.cli_tools/zsh-autosuggestions
echo "source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
## Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.cli_tools/zsh-syntax-highlighting
echo "source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
################################################################################
# Install Miniforge3
if [[ ! -d "~/.miniforge3" ]]; then
    MF3_PATH="$HOME/.miniforge3"
    echo "LOG --> Installing Miniforge3..."
    mkdir $MF3_PATH
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    chmod 700 "./Miniforge3-$(uname)-$(uname -m).sh"
    ./Miniforge3-$(uname)-$(uname -m).sh -b -p $MF3_PATH -f
    rm ./Miniforge3*
    $MF3_PATH/bin/conda init zsh
fi
################################################################################
# Post Run Instructions
echo "DONE"

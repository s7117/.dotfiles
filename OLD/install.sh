#!/bin/bash

# Vars
CURR_DIR=$(pwd)
CURR_OS=$(uname)

echo "LOG --> Creating directories..."
mkdir ~/.cli_tools
mkdir ~/.ssh

# SSH
# echo "LOG --> Copying ssh config..."
# cp ./config ~/.ssh

# Copy vim settings over
echo "LOG --> Copying vimrc..."
cp ./.vimrc ~

# Install zsh
if [[ "$CURR_OS" == *"Linux"* ]]; then
  echo "LOG --> Installing zsh and updating..."
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install zsh -y
  sudo apt install build-essential -y
  sudo apt install wget -y
fi
chsh -s $(which zsh)

# Zsh Settings
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

# Install Homebrew
if [[ "$CURR_OS" == *"Darwin"* ]]; then
  echo "LOG --> Installing Homebrew..."
  curl https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh --output homebrew_install.sh
  chmod 700 homebrew_install.sh
  NONINTERACTIVE=1 /bin/bash -c "./homebrew_install.sh"
  rm ./homebrew_install.sh
fi

# Add Hombrew to path
#if [[ "$CURR_OS" == *"Linux"* ]]; then
  #echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
  #eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if [[ "$CURR_OS" == *"Darwin"* ]]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  eval "$(/opt/hombrew/bin/brew shellenv)"
fi

# Install iTerm2 on MacOS
if [[ "$CURR_OS" == *"Darwin"* ]]; then
  echo "LOG --> Installing iTerm2..."
  brew install --cask iterm2
fi

# Install Oh-My-Posh
echo "LOG --> Installing Oh-My-Posh..."
echo "export XDG_CACHE_HOME=~/.oh-my-posh" >> ~/.zshrc
mkdir ~/.oh-my-posh
mkdir ~/.oh-my-posh/bin
if [[ "$CURR_OS" == *"Linux"* ]]; then
  sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O ~/.oh-my-posh/bin/oh-my-posh
  chmod +x ~/.oh-my-posh/bin/oh-my-posh
  echo 'export PATH=$PATH:~/.oh-my-posh/bin' >> ~/.zshrc
elif [[ "$CURR_OS" == *"Darwin"* ]]; then
  brew tap jandedobbeleer/oh-my-posh
  brew install oh-my-posh
fi

# Oh-my-posh
echo "LOG --> Setting Oh-My-Posh Theme..."
echo 'eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"' >> ~/.zshrc
echo 'source ~/.dotfiles/.zshrc_custom' >> ~/.zshrc

echo "# CLI Tools" >> ~/.zshrc

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.cli_tools/zsh-autosuggestions
echo "source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.cli_tools/zsh-syntax-highlighting
echo "source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# Install Miniforge3
echo "LOG --> Installing Miniforge3..."
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
zsh "./Miniforge3-$(uname)-$(uname -m).sh"
rm ./Miniforge3*

# Post Run Instructions
echo "#### Post-run Instruction ####"
echo "Run:"
echo "    ~/.miniforge3/bin/conda init zsh"
echo "    brew install ..."
echo "DONE"
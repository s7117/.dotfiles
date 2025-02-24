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
sudo apt install zsh build-essential wget curl vim htop \
  fprintd libpam-fprintd network-manager-openconnect \
  network-manager-openconnect-gnome openconnect gimp \
  obs-studio neofetch gnome-tweaks google-chrome-stable -y
sudo pam-auth-update
################################################################################
# Install docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done


# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt repos
sudo apt-get update -y

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add user to docker group
sudo usermod -aG docker $USER

# Enable at startup
sudo systemctl enable docker.service
sudo systemctl enable docker.socket
sudo systemctl start docker.service
sudo systemctl start docker.socket

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
# Fira Code Fonts
curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
| grep "FiraCode.zip" \
| grep "browser_download_url" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
mkdir -p ~/.local/share/fonts
unzip FiraCode.zip -d ~/.local/share/fonts
fc-cache
rm FiraCode.zip
################################################################################
# Install and Configure Oh-My-Posh.
echo "LOG --> Installing Oh-My-Posh..."
echo "export XDG_CACHE_HOME=~/.xdg-cache" >> ~/.zshrc
echo 'export PATH=$PATH:~/.oh-my-posh/bin' >> ~/.zshrc
mkdir ~/.oh-my-posh
mkdir ~/.oh-my-posh/bin
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O ~/.oh-my-posh/bin/oh-my-posh
chmod +x ~/.oh-my-posh/bin/oh-my-posh
echo "LOG --> Setting Oh-My-Posh Theme..."
echo 'eval "$(oh-my-posh init zsh --config ~/.dotfiles/etc/s7117.omp.json)"' >> ~/.zshrc
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
    bash ./Miniforge3-$(uname)-$(uname -m).sh -b -p $MF3_PATH -f
    rm ./Miniforge3*
    $MF3_PATH/bin/conda init zsh
    $MF3_PATH/bin/mamba init zsh
fi
################################################################################
# Post Run Instructions
echo "DONE"

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
    mkdir -p $HOME/.zsh_bups
    cp ~/.zshrc ~/.zsh_bups/.bup.zshrc
    # Delete old .zshrc
    rm "$HOME/.zshrc"
fi
################################################################################
echo "LOG --> Creating directories..."
mkdir -p ~/.cli_tools
mkdir -p ~/.ssh
################################################################################
# Move config files around.
cp ./etc/config ~/.ssh
cp ./etc/vimrc ~/.vimrc
################################################################################
# Install
sudo dnf remove docker \
	docker-client \
	docker-client-latest \
	docker-common \
	docker-latest \
	docker-latest-logrotate \
	docker-logrotate \
	docker-selinux \
	docker-engine-selinux \
	docker-engine

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
	--add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin

echo "LOG --> Check that the following GPG matches:"
echo "LOG --> 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35"


################################################################################
# Services
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny
sleep 1
################################################################################
# Docker Related Services
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable docker.socket
################################################################################
# Connect Your Netowrk Cable
echo "##############################"
echo "Connect your network cable..."
echo "Press enter when ready..."
echo "##############################"
read TEMPCONT
################################################################################
# Configure Zsh
echo "LOG --> Configuring Zsh..."
chsh -s /bin/zsh
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
echo "export XDG_CACHE_HOME=~/.xdg-cache" >> ~/.zshrc
echo 'export PATH=$PATH:~/.oh-my-posh/bin' >> ~/.zshrc
mkdir -p ~/.oh-my-posh
mkdir -p ~/.oh-my-posh/bin
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O ~/.oh-my-posh/bin/oh-my-posh
chmod +x ~/.oh-my-posh/bin/oh-my-posh
echo "LOG --> Setting Oh-My-Posh Theme..."
echo 'eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/etc/s7117.omp.json)"' >> ~/.zshrc
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
    mkdir -p $MF3_PATH
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    chmod 700 "./Miniforge3-$(uname)-$(uname -m).sh"
    ./Miniforge3-$(uname)-$(uname -m).sh -b -p $MF3_PATH -f
    rm ./Miniforge3*
    $MF3_PATH/bin/conda init zsh
fi
################################################################################

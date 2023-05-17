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
# Install software
echo "LOG --> Installing AUR software..."
AURDIR=~/.aurpkgs
mkdir -p $AURDIR
# Install AUR Packages
git clone https://github.com/vinceliuice/grub2-themes $AURDIR/grub2-themes
# Install paru AUR Helper from https://github.com/Morganamilo/paru
git clone https://aur.archlinux.org/paru.git $AURDIR/paru
(cd $AURDIR/paru && makepkg -si)
paru -Syu google-chrome visual-studio-code-bin
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
echo "export XDG_CACHE_HOME=~/.oh-my-posh" >> ~/.zshrc
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
# Grub 2 Theme Setup
# sudo sed -i "s/GRUB_DISABLE_OS_PROBER=true/#GRUB_DISABLE_OS_PROBER=true/g" /etc/default/grub
# sudo echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
#echo "Please enter your monitor resolution: "
#echo "See available resolutions: https://github.com/vinceliuice/grub2-themes"
#echo "[1080p|2k|4k|ultrawide|ultrawide2k]..."
#read MRESOLUTION
#sudo $AURDIR/grub2-themes/install.sh -t vimix -s $MRESOLUTION -i white -b
################################################################################
# Post Run Instructions
echo "DONE: Reboot system for changes to take affect..."

#!/bin/zsh

# Vars
CPATH=$(pwd)

# Change permissions
chmod 700 ./update_omz.zsh

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install dependencies
echo "NOTE: Installing dependencies..."
brew update
echo "NOTE: Installing wget..."
brew install wget
echo "NOTE: Installing hyper..."
brew cask install hyper
echo "NOTE: Installing zsh-autosuggestions..."
brew install zsh-autosuggestions
echo "NOTE: Installing zsh-syntax-highlighting..."
brew install zsh-syntax-highlighting
echo "NOTE: Installing rmtrash..."
brew install rmtrash
echo "NOTE: Brew installs DONE."

# Install oh-my-zsh
cd ~
echo "NOTE: Installing oh-my-zsh..."
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd $CPATH

# Configure oh-my-zsh
### replace default theme
echo "NOTE: Changing default oh-my-zsh theme to agnoster..."
sed -i 's/robbyrussell/agnoster/g' ~/.zshrc

# Append to the end of the .zshrc file
echo "NOTE: Appending zsh custom file..."
echo "source $CPATH/.zshrc_custom" >> ~/.zshrc

# Install fonts
echo "NOTE: Installing fonts..."
cp "$CPATH/fonts/*" "~/Library/Fonts"

# Configure Hyper
### Add Verminal config
# verminal: {
#   fontSize: 16,
#   fontFamily: 'Fira Code'
# }
### Add plugins
# plugins: ['verminal','hypercwd'],

# Configure vimrc
echo "NOTE: Copying vimrc..."
cp "$CPATH/.vimrc" "~/"

echo "NOTE: END of script."

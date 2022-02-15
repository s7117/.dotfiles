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
fi
chsh -s $(which zsh)

# Zsh Settings
echo "LOG --> Setting zsh history..."
echo "HISTFILE=~/.zsh_history" >> ~/.zshrc
echo "HISTSIZE=1000000000" >> ~/.zshrc
echo "SAVEHIST=1000000000" >> ~/.zshrc
echo "setopt appendhistory" >> ~/.zshrc

# Install Homebrew
echo "LOG --> Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Hombrew to path
if [[ "$CURR_OS" == *"Linux"* ]]; then
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$CURR_OS" == *"Darwin"* ]]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  eval "$(/opt/hombrew/bin/brew shellenv)"
fi

# Install base brew packages
brew install gcc make git vim

# Install iTerm2 on MacOS
if [[ "$CURR_OS" == *"Darwin"* ]]; then
  echo "LOG --> Installing iTerm2..."
  brew install --cask iterm2
fi

# Install Oh-My-Posh
echo "LOG --> Installing Oh-My-Posh..."
brew tap jandedobbeleer/oh-my-posh
brew install oh-my-posh

# Oh-my-posh
echo "LOG --> Setting Oh-My-Posh Theme..."
echo 'eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"' >> ~/.zshrc
echo 'source ~/.dotfiles/.zshrc_custom' >> ~/.zshrc

# Install zsh-autosuggestions
brew install zsh-autosuggestions

# Install zsh-syntax-highlighting
brew install zsh-syntax-highlighting

# Install Miniforge3 
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
zsh "./Miniforge3-$(uname)-$(uname -m).sh"
rm ./Miniforge3*

# Post Run Instructions
echo "#### Post-run Instruction ####"
echo "DONE"

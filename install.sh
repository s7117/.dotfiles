mkdir ~/.cli_tools
mkdir ~/.oh-my-posh
mkdir ~/.oh-my-posh/bin

# Vars
CURR_DIR=$(pwd)

# Copy vim settings over
cp ./.vimrc ~

# Zsh Settings
echo "HISTFILE=~/.zsh_history" >> ~/.zshrc
echo "HISTSIZE=10000" >> ~/.zshrc
echo "SAVEHIST=10000" >> ~/.zshrc
echo "setopt appendhistory" >> ~/.zshrc

# Oh-My-Posh Install
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O ~/.oh-my-posh/bin/oh-my-posh
chmod +x ~/.oh-my-posh/bin/oh-my-posh

echo 'export PATH=$PATH:~/.oh-my-posh/bin' >> ~/.zshrc
echo 'eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"' >> ~/.zshrc
echo 'source ~/.dotfiles/.zshrc_custom' >> ~/.zshrc

echo "# CLI Tools" >> ~/.zshrc

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.cli_tools/zsh-autosuggestions
echo "source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.cli_tools/zsh-syntax-highlighting
echo "source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# Install zsh-completions
git clone https://github.com/zsh-users/zsh-completions.git ~/.cli_tools/zsh-completions
export fpath="~/.cli_tools/zsh-completions/src $fpath"
echo "source ~/.cli_tools/zsh-completions/zsh-completions.plugin.zsh" >> ~/.zshrc

# Post Run Instructions
echo "#### Post-run Instruction ####"
echo "Run rm -f ~/.zcompdump* and then run compinit in the home directory."



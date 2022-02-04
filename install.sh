mkdir ~/.cli_tools
mkdir ~/.oh-my-posh
mkdir ~/.oh-my-posh/bin

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

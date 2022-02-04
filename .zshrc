export PATH=$PATH:~/.oh-my-posh/bin
eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"
source ~/.dotfiles/.zshrc_custom
# CLI Tools
source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/homes/psc/.miniforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/homes/psc/.miniforge/etc/profile.d/conda.sh" ]; then
        . "/homes/psc/.miniforge/etc/profile.d/conda.sh"
    else
        export PATH="/homes/psc/.miniforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


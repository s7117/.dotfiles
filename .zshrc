eval "$(oh-my-posh --init --shell zsh --config ~/.dotfiles/s7117.omp.json)"
source ~/.dotfiles/.zshrc_custom
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/s7117/.miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/s7117/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/s7117/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/s7117/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# CLI Tools
source ~/.cli_tools/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.cli_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
